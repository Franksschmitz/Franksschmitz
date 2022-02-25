SELECT
 x.codigo,
 x.empresa,
 x.conta,
 x.nr_conta,
 x.nome_conta,
 CASE
   WHEN (x.mes + 1) = 13 THEN 'JANEIRO'
   WHEN (x.mes + 1) = 2  THEN 'FEVEREIRO'
   WHEN (x.mes + 1) = 3  THEN 'MARCO'
   WHEN (x.mes + 1) = 4  THEN 'ABRIL'
   WHEN (x.mes + 1) = 5  THEN 'MAIO'
   WHEN (x.mes + 1) = 6  THEN 'JUNHO'
   WHEN (x.mes + 1) = 7  THEN 'JULHO'
   WHEN (x.mes + 1) = 8  THEN 'AGOSTO'
   WHEN (x.mes + 1) = 9  THEN 'SETEMBRO'
   WHEN (x.mes + 1) = 10 THEN 'OUTUBRO'
   WHEN (x.mes + 1) = 11 THEN 'NOVEMBRO'
   WHEN (x.mes + 1) = 12 THEN 'DEZEMBRO'
 END AS PERIODO,
 CAST(((x.valor / :Periodo) * :DIAS_PROJECAO)AS NUMERIC(26,2)) PROJECAO,  
 CAST(((x.valor / :Periodo) * (EXTRACT('DAY' FROM (DATE_TRUNC('MONTH', CURRENT_DATE) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')) - EXTRACT(DAY FROM CURRENT_DATE)))AS NUMERIC(26,2)) AS PROJECAO_MES_ATUAL
 
			FROM   (
							SELECT
							    l.id_filial AS CODIGO,
								ep.ds_empresa AS EMPRESA,
								l.id_planoconta AS CONTA,
								p.nr_planoconta AS NR_CONTA,
								p.ds_planoconta AS NOME_CONTA,
								EXTRACT(MONTH FROM current_DATE) AS MES,
								sum(l.vl_valor) AS VALOR
							FROM lanc l
							LEFT JOIN entidade e ON (l.id_entidade = e.id_entidade)
							LEFT JOIN planoconta p ON (l.id_planoconta = p.id_planoconta)
							JOIN empresa ep ON (l.id_filial = ep.id_empresa)
								WHERE l.ch_excluido IS NULL					
								AND l.id_planoconta IN (
															SELECT id_planoconta FROM planoconta 
																WHERE (nr_planoconta LIKE '03.%' OR nr_planoconta = '02.01.001')
																AND ds_planoconta NOT LIKE '%CUSTO%')
								AND l.ch_debcre = p.ch_natureza    		
                            	AND l.id_filial =:Empresa 
								AND l.dh_lanc > CAST(CURRENT_DATE - CAST(:Periodo AS INTEGER)AS DATE)
							
							{IF PARAM_PlanoConta} AND p.id_planoconta IN (:PlanoConta) {ENDIF}
							
							GROUP BY 1,2,3,4,5
			) x
GROUP BY 1,2,3,4,5,6,7,8
