select * 
from (
    select
        l2.DH_LANC EMISSAO,
        l2.DT_BAIXA as baixa,   
        'DESPESA A PAGAR' TIPO,
        case
           when l.ID_ENTIDADE = ''        then '1-1'
           when l.ID_ENTIDADE is null     then '1-1'
	    else l.ID_ENTIDADE
        end as CODIGO,
        case
           when l.ID_ENTIDADE = '1-1'    then 'FORNECEDOR NAO IDENTIFICADO'
           when l.ID_ENTIDADE = '2684-1' then 'FORNECEDOR NAO IDENTIFICADO'
           when l.ID_ENTIDADE = '2680-1' then 'FORNECEDOR NAO IDENTIFICADO'
           when l.ID_ENTIDADE is null    then 'FORNECEDOR NAO IDENTIFICADO'
	   else e.DS_ENTIDADE
        end as FORNECEDOR,
        l.DS_HISTORICO as HISTORICO,
        l.NR_DOCUME as DOCUMENTO,
        l.DT_VENCIM as VENCIMENTO,
        case
          when l2.VL_DESCON <> '0' then l2.VL_PAGO		
		  else l.VL_VALOR 
		end as VALOR,   
        l.ID_PLANOCONTA,
        p.DS_PLANOCONTA,
        p.NR_PLANOCONTA,
        ep.ID_EMPRESA,
        ep.DS_EMPRESA
    from LANC l
    join LANC l2 on (l.ID_AGRU = l2.ID_AGRU and l2.ID_LANC <> l.id_LANC)
    left join ENTIDADE e on (l.ID_ENTIDADE = e.ID_ENTIDADE)
    left join PLANOCONTA p on (l.ID_PLANOCONTA = p.ID_PLANOCONTA)
    join EMPRESA ep on (l.ID_FILIAL = ep.ID_EMPRESA)
        where l.CH_EXCLUIDO is null 
        and l.ID_PLANOCONTA in (
                                    select ID_PLANOCONTA from PLANOCONTA 
                                        where (NR_PLANOCONTA like '03.%' or NR_PLANOCONTA = '01.04')
                                        and NR_PLANOCONTA <> '03.08')
        and l.CH_DEBCRE = p.CH_NATUREZA    
        and l2.CH_SITUAC = 'L'
        and l2.DT_BAIXA between cast(:emissao_ini as date) and cast(:emissao_fim as date)
    
    UNION ALL

    select
        l2.DH_LANC EMISSAO,
        l2.DH_LANC as baixa,   
        'DESPESA BAIXADA' TIPO,
        case
           when l.ID_ENTIDADE = ''        then '1-1'
           when l.ID_ENTIDADE is null     then '1-1'
	    else l.ID_ENTIDADE
        end as CODIGO,
        case
           when l.ID_ENTIDADE = '1-1'    then 'FORNECEDOR NAO IDENTIFICADO'
           when l.ID_ENTIDADE = '2684-1' then 'FORNECEDOR NAO IDENTIFICADO'
           when l.ID_ENTIDADE = '2680-1' then 'FORNECEDOR NAO IDENTIFICADO'
           when l.ID_ENTIDADE is null    then 'FORNECEDOR NAO IDENTIFICADO'
	    else e.DS_ENTIDADE
        end as FORNECEDOR,
        l.DS_HISTORICO as HISTORICO,
        l.NR_DOCUME as DOCUMENTO,
        l.DT_VENCIM as VENCIMENTO,
        case
          when l2.VL_DESCON <> '0' then l2.VL_PAGO		
		  else l.VL_VALOR 
		end as VALOR,    
        l.ID_PLANOCONTA,
        p.DS_PLANOCONTA,
        p.NR_PLANOCONTA,
        ep.ID_EMPRESA,
        ep.DS_EMPRESA
    from LANC l
    join LANC l2 on (l.ID_AGRU = l2.ID_AGRU and l2.ID_LANC <> l.id_LANC)
    left join ENTIDADE e on (l.ID_ENTIDADE = e.ID_ENTIDADE)
    left join PLANOCONTA p on (l.ID_PLANOCONTA = p.ID_PLANOCONTA)
    join EMPRESA ep on (l.ID_FILIAL = ep.ID_EMPRESA)
        where l.CH_EXCLUIDO is null 
        and l.ID_PLANOCONTA in (
                                    select ID_PLANOCONTA from PLANOCONTA 
                                        where (NR_PLANOCONTA like '03.%' or NR_PLANOCONTA = '01.04')
                                        and NR_PLANOCONTA <> '03.08')
        and l.CH_DEBCRE = p.CH_NATUREZA    		
        and l2.CH_SITUAC = 'N'
        and l2.DH_LANC between :emissao_ini and :emissao_fim
) s 
{if param_Empresa} where ID_EMPRESA in (:Empresa) {endif}
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
order by 12,1,2
