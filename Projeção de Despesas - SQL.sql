select
 x.codigo,
 x.empresa,
 case
   when (x.mes + 1) = 13 then 'JANEIRO'
   when (x.mes + 1) = 2  then 'FEVEREIRO'
   when (x.mes + 1) = 3  then 'MARCO'
   when (x.mes + 1) = 4  then 'ABRIL'
   when (x.mes + 1) = 5  then 'MAIO'
   when (x.mes + 1) = 6  then 'JUNHO'
   when (x.mes + 1) = 7  then 'JULHO'
   when (x.mes + 1) = 8  then 'AGOSTO'
   when (x.mes + 1) = 9  then 'SETEMBRO'
   when (x.mes + 1) = 10 then 'OUTUBRO'
   when (x.mes + 1) = 11 then 'NOVEMBRO'
   when (x.mes + 1) = 12 then 'DEZEMBRO'
 end as PERIODO,
 cast(((x.VALOR / :Periodo) * :DIAS_PROJECAO)as numeric(26,2)) PROJECAO,  
 cast(((x.VALOR / :Periodo) * (EXTRACT('day' FROM (DATE_TRUNC('MONTH', CURRENT_DATE) + INTERVAL '1 month' - INTERVAL '1 day')) - EXTRACT(DAY FROM CURRENT_DATE)))as numeric(26,2)) as PROJECAO_MES_ATUAL
 
			from   (
							select
							      l.id_filial CODIGO,
								  ep.ds_empresa EMPRESA,
                                  extract(month from current_date) MES,
								  sum(l.vl_valor) VALOR
							from LANC l
							left join ENTIDADE e on (l.ID_ENTIDADE = e.ID_ENTIDADE)
							left join PLANOCONTA p on (l.ID_PLANOCONTA = p.ID_PLANOCONTA)
							join EMPRESA ep on (l.ID_FILIAL = ep.ID_EMPRESA)
							where l.CH_EXCLUIDO is null					
							and l.ID_PLANOCONTA in (
								select ID_PLANOCONTA from PLANOCONTA 
								where (NR_PLANOCONTA like '03.%' or NR_PLANOCONTA = '02.01.001.0067')
								and DS_PLANOCONTA not like '%CUSTO%')
							and l.CH_DEBCRE = p.CH_NATUREZA    		
                            and l.id_filial =:Empresa 
							and l.DH_LANC > cast(current_date - cast(:Periodo as integer)as date)
							group by 1,2
			) x
group by 1,2,3,4,5

/*

Este relatório faz uma projeção das despesas do mês posterior ao mês atual, utilizando como base os dados de períodos passados e também faz uma projeção do valor total de despesas a serem lançadas até o final do mês atual. 

O relatório filtra por: 

- Empresa: inserir o código da empresa desejada;
- Período: inserir o número de dias desejado para que o relatório utilize como base de informações para montar na tela para o usuário;
- Projeção Em Dias: inserir o número de dias que deseja ver projetados.

Lembrando que o relatório traz apenas um valor total de projeção para o mês e não por dias ou semanas.

*/
