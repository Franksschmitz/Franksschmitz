WITH caixas AS (

					SELECT 
						cp.id_caixapdv,
						cp.id_caixacfg,
						cp.dt_abertura
					FROM  caixapdv cp
						WHERE cp.ch_situac <>  'A'
						AND cp.id_caixapdv IN (:id_caixapdv)

), gnv AS (

					SELECT 
						CAST( :valor_dinheiro AS NUMERIC(12,2) ) AS GNV_DINHEIRO,
						CAST( :valor_credito  AS NUMERIC(12,2) ) AS GNV_CREDITO,
						CAST( :valor_debito   AS NUMERIC(12,2) ) AS GNV_DEBITO,
						CAST( :valor_nota     AS NUMERIC(12,2) ) AS GNV_NOTA,
						CAST( :valor_falta    AS NUMERIC(12,2) ) AS GNV_FALTA,
						CAST( :valor_sobra    AS NUMERIC(12,2) ) AS GNV_SOBRA,
						CAST( :qtd_gnv        AS NUMERIC(12,2) ) AS GNV_QUANTIDADE,
						CAST( :valor_gnv      AS NUMERIC(12,2) ) AS GNV_VALOR

), faltas AS (

	
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

), dados AS (

					SELECT
						cg.ds_caixacfg,
						SUM(CASE WHEN ec.id_especie = '2-1' THEN cf.vl_valor ELSE 0 END) AS VL_DINHEIRO,
						SUM(CASE WHEN ec.id_especie = '10-1' THEN cf.vl_valor ELSE 0 END) AS VL_CARTAO_CREDITO,
						SUM(CASE WHEN ec.id_especie = '14-1' THEN cf.vl_valor ELSE 0 END) AS VL_CARTAO_DEBITO,
						SUM(CASE WHEN ec.id_especie = '3-1' THEN cf.vl_valor ELSE 0 END) AS VL_NOTA,
						SUM(cf.vl_valor) AS VL_TOTAL,
						SUM(CASE WHEN ec.id_especie = '2-1' THEN ft.vl_valor ELSE 0 END) AS VL_FALTA,
						SUM(CASE WHEN ec.id_especie = '2-1' THEN cf.vl_sobra ELSE 0 END) AS VL_SOBRA
					FROM caixas cp
					INNER JOIN caixacfg AS cg ON(cg.id_caixacfg = cp.id_caixacfg)
					INNER JOIN caixapdv_fec AS cf ON (cf.id_caixapdv = cp.id_caixapdv)
					INNER JOIN especie AS ec ON (ec.id_especie = cf.id_especie)
					LEFT JOIN faltas AS ft ON(ft.id_caixapdv = cp.id_caixapdv)
					GROUP BY 1

)

	SELECT 
		da.*,
		da.vl_total + da.vl_sobra - da.vl_falta AS VL_GERAL,
		0 AS QTD_LITROS,
		0 AS VALOR_VENDA 
	FROM dados AS da

	UNION ALL
	
	SELECT 
		'GNV' AS DS_CAIXACFG,
		gnv_dinheiro AS VL_DINHEIRO,
		gnv_credito AS VL_CARTAO_CREDITO,
		gnv_debito As VL_CARTAO_DEBITO,
		gnv_nota AS VL_NOTA,
		(gnv_dinheiro + gnv_credito + gnv_debito + gnv_nota) AS VL_TOTAL,
		gnv_falta AS VL_FALTA,
		gnv_sobra AS VL_SOBRA,
		((gnv_dinheiro + gnv_credito + gnv_debito + gnv_nota) + gnv_sobra - gnv_falta) AS VL_GERAL,
		gnv_quantidade AS QTD_LITROS,
		gnv_valor AS VALOR_VENDA 
	FROM gnv
	
ORDER BY DS_CAIXACFG
