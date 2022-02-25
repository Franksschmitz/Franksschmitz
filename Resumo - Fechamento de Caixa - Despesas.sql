WITH caixas AS (

					SELECT 
						cp.id_caixapdv,
						cp.id_caixacfg,
                        cx1.ds_caixacfg
					FROM  caixapdv cp
                    LEFT JOIN caixacfg cx1 ON (cp.id_caixacfg = cx1.id_caixacfg)
						WHERE cp.ch_situac <>  'A'
						AND cp.id_caixapdv IN (:id_caixapdv)
 
)

SELECT 
    *
FROM (
        SELECT
            cx.ds_caixacfg,
            l.DS_HISTORICO as HISTORICO,
            l.NR_DOCUME as DOCUMENTO,
            CASE
                WHEN l2.VL_DESCON <> '0' THEN l2.VL_PAGO		
                ELSE l.VL_VALOR 
            END AS VALOR,   
            p.DS_PLANOCONTA
        FROM LANC l
        JOIN LANC l2 ON (l.ID_AGRU = l2.ID_AGRU AND l2.ID_LANC <> l.id_LANC)
        INNER JOIN caixas AS cx ON (cx.id_caixapdv = l.id_caixapdv)
        LEFT JOIN ENTIDADE e ON (l.ID_ENTIDADE = e.ID_ENTIDADE)
        LEFT JOIN PLANOCONTA p ON (l.ID_PLANOCONTA = p.ID_PLANOCONTA)
        LEFT JOIN EMPRESA ep ON (l.ID_FILIAL = ep.ID_EMPRESA)
            WHERE l.CH_EXCLUIDO IS NULL 
            AND l.ID_PLANOCONTA IN (
                                        SELECT ID_PLANOCONTA FROM PLANOCONTA 
                                            WHERE (NR_PLANOCONTA LIKE '03.%' OR NR_PLANOCONTA = '01.04')
                                            AND NR_PLANOCONTA <> '03.08')
            AND l.CH_DEBCRE = p.CH_NATUREZA    
            AND l2.CH_SITUAC = 'L'
	
    UNION ALL

        SELECT
            cx.ds_caixacfg,
            l.DS_HISTORICO as HISTORICO,
            l.NR_DOCUME as DOCUMENTO,
            CASE
                WHEN l2.VL_DESCON <> '0' THEN l2.VL_PAGO		
                ELSE l.VL_VALOR 
            END AS VALOR,   
            p.DS_PLANOCONTA
        FROM LANC l
        JOIN LANC l2 ON (l.ID_AGRU = l2.ID_AGRU AND l2.ID_LANC <> l.id_LANC)
        INNER JOIN caixas AS cx ON (cx.id_caixapdv = l.id_caixapdv)
        LEFT JOIN ENTIDADE e ON (l.ID_ENTIDADE = e.ID_ENTIDADE)
        LEFT JOIN PLANOCONTA p ON (l.ID_PLANOCONTA = p.ID_PLANOCONTA)
        LEFT JOIN EMPRESA ep ON (l.ID_FILIAL = ep.ID_EMPRESA)
            WHERE l.CH_EXCLUIDO IS NULL 
            AND l.ID_PLANOCONTA IN (
                                        SELECT ID_PLANOCONTA FROM PLANOCONTA 
                                            WHERE (NR_PLANOCONTA LIKE '03.%' OR NR_PLANOCONTA = '01.04')
                                            AND NR_PLANOCONTA <> '03.08')
            AND l.CH_DEBCRE = p.CH_NATUREZA   		
    AND l2.CH_SITUAC = 'N'
    
) s 

ORDER BY 1
