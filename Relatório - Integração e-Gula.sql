SELECT
    a.id_item AS CODIGO,
    a.nr_fantasia AS FANTASIA,
    a.ds_item AS DESCRICAO,
    a.nr_codbar AS COD_BARRAS,
    c.qt_estoque AS ESTOQUE,
    b.vl_preco AS PRECO
FROM item a
LEFT JOIN item_preco b ON a.id_item = b.id_item
LEFT JOIN localarm_item c ON a.id_item = c.id_item
    WHERE a.ch_combustivel <> 'T'
    AND a.ch_ativo = 'T'
    AND a.ch_excluido IS NULL
    AND b.ch_excluido IS NULL
    AND c.ch_excluido IS NULL
    AND c.id_localarm = (:Deposito)
    AND c.qt_estoque > 0
    AND c.id_localarm_item IN ( SELECT MAX(id_localarm_item) FROM localarm_item
                                    WHERE id_item = a.id_item
                                    AND ch_excluido IS NULL
                                    AND dh_update < CAST((:STATUS || ' ' || CURRENT_TIME) AS DATAHORA))


GROUP BY 1,2,3,4,5,6
ORDER BY 3