SELECT 
    d.dh_emissa AS DATAHORA,
    d.id_entidade AS CODIGO,
    b.ds_entidade AS CLIENTE,
    'VENDA' AS TIPO,
    d.nr_docfiscal AS DOC,
    di.id_item AS COD,
    di.ds_item AS ITEM,
    di.vl_unitar AS PRECO,
    di.qt_item AS QTD,
    di.vl_total AS TOTAL_ITEM,
    db.vl_valor AS TOTAL_PAGO
FROM docfiscal d
LEFT JOIN docfiscal_item di ON d.id_docfiscal = di.id_docfiscal
LEFT JOIN entidade b ON d.id_entidade = b.id_entidade
LEFT JOIN empresa c ON d.id_filial = c.id_empresa
LEFT JOIN docfiscal_baixa db ON d.id_docfiscal = db.id_docfiscal
    WHERE d.id_especie = '4-1'
    AND d.ch_situac = 'F'
    AND d.ch_sitpdv = 'F'
    AND d.ch_tipo <> 'NFE'
    AND di.ch_excluido IS NULL
    AND db.ch_excluido IS NULL
    AND db.ch_baixa = 'T'
    AND d.dt_emissa BETWEEN CAST((:emissao_ini || ' 00:01') AS TIMESTAMP) AND CAST((:emissao_fim || ' 23:59') AS TIMESTAMP)


{IF PARAM_Empresa} AND d.id_filial IN (CASE
                                            WHEN c.ch_vinculada = 'T' THEN c.id_filial
                                            ELSE (:Empresa) END) {ENDIF}
{IF PARAM_Entidade} AND d.id_entidade IN (:Entidade) {ENDIF}
{IF PARAM_Emissao_ini} AND d.dh_emissa BETWEEN CAST((:emissao_ini || ' 00:01') AS TIMESTAMP) AND CAST((:emissao_fim || ' 23:59') AS TIMESTAMP) {ENDIF}

ORDER BY 1
