SELECT
    x.empresa,
    x.localarm,
    x.item,
    x.descricao,
    x.qt_estoque,
    x.preco_compra,
    CAST((x.qt_estoque * x.preco_compra) AS NUMERIC(26,3)) AS VL_CUSTO_EST,
    x.qt_compra,
    x.vl_compra_1,
    CAST(((x.qt_estoque * x.preco_compra) + x.vl_compra_1) / (x.qt_estoque + x.qt_compra)AS NUMERIC(26,3)) AS PRECO_MEDIO,
    x.preco_venda,
    CAST(x.preco_venda - (((x.qt_estoque * x.preco_compra) + x.vl_compra_1) / (x.qt_estoque + x.qt_compra)) AS NUMERIC(26,3)) AS LUCRO_BRUTO_LT,
    x.qt_venda,
    CAST((CAST(((x.qt_estoque * x.preco_compra) + x.vl_compra_1) / (x.qt_estoque + x.qt_compra) AS NUMERIC(26,3)) * x.qt_venda) AS NUMERIC(26,3)) AS CUSTO_VENDA,
    CAST((x.preco_venda * x.qt_venda) AS NUMERIC(26,3)) AS VALOR_VENDA,
    CAST((x.preco_venda * x.qt_venda) AS NUMERIC(26,3)) - CAST((CAST(((x.qt_estoque * x.preco_compra) + x.vl_compra_1) / (x.qt_estoque + x.qt_compra) AS NUMERIC(26,3)) * x.qt_venda) AS NUMERIC(26,3)) AS LUCRO_BRUTO_TOTAL
FROM (

            SELECT 
                a.id_filial AS EMPRESA,
                a.id_localarm AS LOCALARM,
                a.id_item AS ITEM,
                c.ds_item AS DESCRICAO,
                b.qt_item AS QT_ESTOQUE,
                (SELECT vl_precom FROM movest_item 
                    WHERE id_filial = a.id_filial 
                    AND id_item = a.id_item
                    AND dt_movime BETWEEN '2000-01-01' AND cast (:Data_ini AS DATE)
                    AND ch_excluido IS NULL
                ORDER BY dt_movime DESC
                LIMIT 1 
                ) AS PRECO_COMPRA,
                SUM(g.qt_rateio) AS QT_COMPRA,
                SUM(d.vl_total) AS VL_COMPRA_1,
                (SELECT AVG(vl_preco_nov) FROM reajuste_det
                    WHERE id_item = a.id_item 
                    AND id_filial = a.id_filial 
                    AND ch_excluido IS NULL
                    AND CAST(dh_reajuste AS DATE) BETWEEN :Data_ini AND :Data_fim
                    AND id_reajuste IN ( SELECT id_reajuste FROM reajuste WHERE ch_situac = 'L' AND ch_excluido IS NULL )
                ) AS PRECO_VENDA,
                (SELECT SUM(di.qt_item) FROM docfiscal_item di
                LEFT JOIN docfiscal bb ON di.id_docfiscal = bb.id_docfiscal
                    WHERE bb.ch_situac = 'F'
                    AND bb.ch_sitpdv = 'F'
                    AND di.ch_excluido IS NULL
                    AND bb.ch_excluido IS NULL
                    AND bb.ch_tipo IN ('CF','CFE','NFCE')
                    AND bb.id_filial = a.id_filial
                    AND di.id_item = a.id_item 
                    AND bb.dt_emissa BETWEEN :Data_ini AND :Data_fim) AS QT_VENDA
            FROM movest_item a
            LEFT JOIN invent b ON (a.id_item = b.id_item)
            LEFT JOIN item c ON (b.id_item = c.id_item)
            LEFT JOIN nft_item d ON (a.id_nft_item = d.id_nft_item)
            LEFT JOIN nft e ON (d.id_nft = e.id_nft)
            LEFT JOIN localarm f ON (a.id_localarm = f.id_localarm)
            LEFT JOIN nft_item_localarm g ON (d.id_nft_item = g.id_nft_item)
                WHERE a.ch_excluido IS NULL
                AND b.ch_excluido IS NULL
                AND d.ch_excluido IS NULL
                AND c.ch_excluido IS NULL
                AND e.ch_excluido IS NULL
                AND f.ch_excluido IS NULL
                AND g.ch_excluido IS NULL
                AND a.id_nft_item IS NOT NULL
                AND f.ch_combustivel = 'T'
                AND c.ch_combustivel = 'T'
                AND c.ch_ativo = 'T'
                AND b.ch_tipo = 'M'
                AND b.ch_situac = 'F'
                AND e.id_filial = f.id_filial
                AND a.id_filial = e.id_filial
                AND a.id_filial =:Empresa
                AND a.id_item IN (SELECT id_item FROM item WHERE id_grupoitem =:GrupoItem OR id_item IN (:Item) AND ch_ativo = 'T' AND ch_excluido IS NULL)
                AND e.dt_saicheg BETWEEN CAST(:Data_ini AS DATE) AND CAST(:Data_fim AS DATE)
                AND b.id_seq IN ( SELECT MAX(id_seq) FROM invent
                                    WHERE id_filial = a.id_filial
                                    AND id_item = a.id_item
                                    AND ch_excluido IS NULL
                                    AND ch_tipo = 'M'
                                    AND ch_situac = 'F'
                                    AND dh_finaliza BETWEEN '1900-01-01' AND CAST(:Data_ini AS DATE))

        {IF param_filial} AND a.id_filial IN (:Empresa) {endif}    
        {IF param_item} AND c.id_item IN (:Item) {endif}
        {IF param_emissao_ini} AND e.dt_saicheg BETWEEN CAST(:Data_ini AS DATE) AND CAST(:Data_fim AS DATE) {endif}
            
        GROUP BY 1,2,3,4,5
        ORDER BY 4

) x