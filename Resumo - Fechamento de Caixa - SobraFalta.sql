WITH caixas AS (

					SELECT 
						cp.id_caixapdv,
						cp.id_caixacfg,
						cp.dt_abertura
					FROM  caixapdv cp
						WHERE cp.ch_situac <>  'A'
						AND cp.id_caixapdv IN (:id_caixapdv)
         
)
	
    SELECT
        la.id_caixapdv,
        en.ds_entidade,
        la.vl_valor
    FROM lanc la
    INNER JOIN entidade AS en ON (en.id_entidade = la.id_entidade)
    INNER JOIN caixas AS cx ON(cx.id_caixapdv = la.id_caixapdv)
        WHERE la.id_tipolanc = '24-1'
        AND la.id_especie = '2-1'
        AND la.ch_excluido IS NULL
