SELECT
    x.cupom,
    x.nota,
    x.emissao,
    x.placa,
    x.qtd,
    x.km_ini,
    x.km_fim,
    x.media,
    x.item,
    x.preco_cadastro,
    x.valor,
    x.preco_tabela,
    CAST(x.valor_tabela AS DECIMAL(20,3))
FROM (

        SELECT 
            r.id_reparc,
            r.id_entidade AS ENTIDADE,
            e.ds_razao AS NOME,
            e.ds_cpfcnpj AS CPFCNPJ,
            g.dt_emissa AS DT_FATURA,
            l.dt_vencim AS VENCIMENTO,
            l.nr_docume AS NR_FATURA,
            d.nr_docfiscal AS CUPOM,
            d2.nr_docfiscal AS NOTA,
            d.dt_emissa AS EMISSAO,
            d.ds_placa AS PLACA,
            di.qt_item AS QTD,
            d.vl_kmhm_ant AS KM_INI,
            d.vl_kmhm AS KM_FIM,
            CAST(((d.vl_kmhm - d.vl_kmhm_ant) / di.qt_item) AS NUMERIC(20,3)) AS MEDIA,
            di.ds_item AS ITEM,
            di.vl_unitar AS PRECO_CADASTRO,
            CAST((di.qt_item * di.vl_unitar) AS NUMERIC(20,4)) AS VALOR,
            CAST((di.vl_total / di.qt_item) AS NUMERIC(20,4)) AS PRECO_TABELA,
            CAST((CAST((di.vl_total / di.qt_item) AS NUMERIC(20,4)) * di.qt_item) AS NUMERIC(20,4)) VALOR_TABELA
        FROM reparc r
        LEFT JOIN gerafat g ON r.id_gerafat = g.id_gerafat
        LEFT JOIN lanc l ON r.id_reparc = l.id_reparc
        LEFT JOIN entidade e ON r.id_entidade = e.id_entidade        
        LEFT JOIN lanc_det ld ON l.id_lanc = ld.id_lanc 
        LEFT JOIN lanc l2 ON ld.id_lanc_bai = l2.id_lanc
        LEFT JOIN docfiscal_item di ON l2.id_docfiscal = di.id_docfiscal
        LEFT JOIN docfiscal d ON di.id_docfiscal = d.id_docfiscal
        LEFT JOIN docfiscal_docref rf ON d.id_docfiscal = rf.id_docfiscal_ref
        LEFT JOIN docfiscal d2 ON rf.id_docfiscal = d2.id_docfiscal
            WHERE g.ch_excluido IS NULL
            AND r.ch_excluido IS NULL
            AND di.ch_excluido IS NULL
            AND d.ch_excluido IS NULL
            AND e.ch_excluido IS NULL
            AND l.ch_excluido IS NULL
            AND rf.ch_excluido IS NULL
            AND d2.ch_excluido IS NULL
            AND d2.ch_situac = 'F'
            AND d.ch_situac = 'F'
            AND d.ch_sitpdv = 'F'
            AND l.ch_situac = 'R'
            AND r.id_reparc IN (:ID)

) x

ORDER BY 3,1