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

)


    SELECT
        x.COMBUSTIVEL,
        x.QUANTIDADE,
        x.VALOR_TOTAL
    FROM (
            SELECT i.DS_ITEM AS COMBUSTIVEL, 
                SUM(di.QT_ITEM) AS QUANTIDADE,           
                SUM(di.VL_BRUTO -  COALESCE(di.VL_DESCON, 0)  + COALESCE(di.VL_ACRES, 0)) as VALOR_TOTAL
            FROM DOCFISCAL d 
            INNER JOIN DOCFISCAL_ITEM AS di ON (d.ID_DOCFISCAL = di.ID_DOCFISCAL)
            INNER JOIN ITEM AS i ON (i.ID_ITEM = di.ID_ITEM)
            INNER JOIN caixas AS cx ON (cx.id_caixapdv = d.id_caixapdv)
                WHERE d.CH_EXCLUIDO IS NULL 
                AND d.CH_SITUAC = 'F'  
                AND d.CH_OPERAC = 'S' 
                AND d.CH_TIPO <> 'VEN'
                AND di.CH_EXCLUIDO IS NULL
                AND di.CH_GERARECPAG = 'T' 
                AND i.CH_COMBUSTIVEL = 'T'
            GROUP BY 1

            UNION ALL
            
            SELECT
                'GNV' AS COMBUSTIVEL,
                gnv_quantidade AS QUANTIDADE,
                gnv_valor AS VALOR_TOTAL
            FROM gnv
    
) x
