SELECT
    x.empresa,
    x.codigo,
    x.entidade,
    CASE
        WHEN x.mes = 1  THEN x.ano || ' / ' || 'JANEIRO'
        WHEN x.mes = 2  THEN x.ano || ' / ' || 'FEVEREIRO'
        WHEN x.mes = 3  THEN x.ano || ' / ' || 'MARÇO'
        WHEN x.mes = 4  THEN x.ano || ' / ' || 'ABRIL'
        WHEN x.mes = 5  THEN x.ano || ' / ' || 'MAIO'
        WHEN x.mes = 6  THEN x.ano || ' / ' || 'JUNHO'
        WHEN x.mes = 7  THEN x.ano || ' / ' || 'JULHO'
        WHEN x.mes = 8  THEN x.ano || ' / ' || 'AGOSTO'
        WHEN x.mes = 9  THEN x.ano || ' / ' || 'SETEMBRO'
        WHEN x.mes = 10 THEN x.ano || ' / ' || 'OUTUBRO'
        WHEN x.mes = 11 THEN x.ano || ' / ' || 'NOVEMBRO'
        WHEN x.mes = 12 THEN x.ano || ' / ' || 'DEZEMBRO'
    END AS PERIODO,
    x.quant,
    x.valor_bruto,
    x.desconto,
    x.acrescimo,
    x.valor_pago,
    x.custo,
    y.mes_ant,
    y.valor_pago_ant,
    y.custo_ant,
    (y.valor_pago_ant - y.custo_ant) AS VALOR_LIQ_ANT,
    (x.valor_pago - x.custo) AS VALOR_LIQ,
    CAST(((((x.valor_pago - x.custo) / (y.valor_pago_ant - y.custo_ant)) * 100) - 100)AS NUMERIC(26,3)) AS VARIACAO
FROM (
        SELECT
            a.id_filial AS EMPRESA,
            a.id_entidade AS CODIGO,
            b.ds_entidade AS ENTIDADE,
            EXTRACT(YEAR FROM a.dt_emissa) AS ANO,
            EXTRACT(MONTH FROM a.dt_emissa) AS MES,
            SUM(c.qt_item) AS QUANT,
            SUM(c.vl_bruto) AS VALOR_BRUTO,
            CASE
                WHEN SUM(c.vl_bruto) - SUM(c.vl_total) > 0 THEN SUM(c.vl_bruto) - SUM(c.vl_total)
                ELSE 0
            END AS DESCONTO,
            CASE
                WHEN SUM(c.vl_total) - SUM(c.vl_bruto) > 0 THEN SUM(c.vl_total) - SUM(c.vl_bruto)
                ELSE 0
            END AS ACRESCIMO,
            SUM(c.vl_total) AS VALOR_PAGO,
            CAST(SUM(c.vl_precus * c.qt_item)AS NUMERIC(26,3)) AS CUSTO
        FROM docfiscal a 
        LEFT JOIN entidade b ON (a.id_entidade = b.id_entidade)
        LEFT JOIN docfiscal_item c ON (a.id_docfiscal = c.id_docfiscal)
            WHERE a.ch_situac = 'F'
            AND a.ch_sitpdv = 'F'
            AND a.id_tipolanc IN ( SELECT id_tipolanc FROM tipolanc WHERE ds_tipolanc LIKE 'VENDA%%NF%' )
            AND a.ch_excluido IS NULL 
            AND c.ch_excluido IS NULL
            AND a.id_filial =:Empresa
            AND a.id_entidade IN (:Entidade)
            AND a.dt_emissa > (CASE 
                                    WHEN (EXTRACT(YEAR FROM a.dt_emissa) || '-' || (EXTRACT(MONTH FROM a.dt_emissa) - 1) || '-01') = '2021-0-01' 
                                    THEN CAST(((EXTRACT(YEAR FROM a.dt_emissa) -1) || '-12-01')AS DATE)
                                    ELSE CAST((EXTRACT(YEAR FROM a.dt_emissa) || '-' || (EXTRACT(MONTH FROM a.dt_emissa) - 1) || '-01')AS DATE) 
                                END)

        {IF param_Empresa} AND a.id_filial IN (:Empresa) {ENDIF}
        {IF param_Entidade} AND a.id_entidade IN (:Entidade) {ENDIF}

        GROUP BY 1,2,3,4,5
 
) x,

 (      SELECT
            a.id_filial AS EMPRESA,
            a.id_entidade AS CODIGO,
            EXTRACT(YEAR FROM a.dt_emissa) AS ANO_ANT,
            EXTRACT(MONTH FROM a.dt_emissa) AS MES_ANT,
            CAST(SUM(c.vl_precus * c.qt_item)AS NUMERIC(26,3)) AS CUSTO_ANT,
            SUM(c.vl_total) AS VALOR_PAGO_ANT
        FROM docfiscal a 
        LEFT JOIN entidade b ON (a.id_entidade = b.id_entidade)
        LEFT JOIN docfiscal_item c ON (a.id_docfiscal = c.id_docfiscal)
            WHERE a.ch_situac = 'F'
            AND a.ch_sitpdv = 'F'
            AND a.id_tipolanc IN ( SELECT id_tipolanc FROM tipolanc WHERE ds_tipolanc LIKE 'VENDA%%NF%' )
            AND a.ch_excluido IS NULL 
            AND c.ch_excluido IS NULL
            AND a.id_filial =:Empresa
            AND a.id_entidade IN (:Entidade)
            AND a.dt_emissa > (CASE 
                                    WHEN (EXTRACT(YEAR FROM a.dt_emissa) || '-' || (EXTRACT(MONTH FROM a.dt_emissa) - 1) || '-01') = '2021-0-01' 
                                    THEN CAST(((EXTRACT(YEAR FROM a.dt_emissa) - 1) || '-12-01')AS DATE)
                                    ELSE CAST((EXTRACT(YEAR FROM a.dt_emissa) || '-' || (EXTRACT(MONTH FROM a.dt_emissa) - 1) || '-01')AS DATE) 
                                END)

        {IF param_Empresa} AND a.id_filial IN (:Empresa) {ENDIF}
        {IF param_Entidade} AND a.id_entidade IN (:Entidade) {ENDIF}

        GROUP BY 1,2,3,4

 
 ) y 

WHERE x.mes IN (CASE 
                    WHEN (y.mes_ant + 1) = 13 THEN 1
                    WHEN y.mes_ant = NULL THEN 100
                    ELSE (y.mes_ant + 1)
                END)
AND x.ano BETWEEN (:Ano) AND (:Ate)

ORDER BY 1,3,x.ano ASC,x.mes ASC