SELECT
    x.empresa,
    x.cod,
    x.vendedor,
    x.cod_grupo,
    x.grupo,
    x.qtd,
    x.valor
FROM (

        SELECT
            CASE
                WHEN h.ch_vinculada <> 'T' THEN a.id_filial
                ELSE h.id_filial
            END AS EMPRESA,
            CASE
                WHEN b.id_vendedor = NULL THEN d.id_entidade
                WHEN b.id_vendedor IS NULL THEN d.id_entidade
                ELSE b.id_vendedor
            END AS COD,
            CASE
                WHEN b.id_vendedor = NULL THEN d.ds_entidade
                WHEN b.id_vendedor IS NULL THEN d.ds_entidade
                ELSE e.ds_entidade
            END AS VENDEDOR,
            g.id_grupoitem AS COD_GRUPO,
            g.ds_grupoitem AS GRUPO,
            SUM(b.qt_item) AS QTD,
            SUM(b.vl_total) AS VALOR
        FROM docfiscal a 
        LEFT JOIN docfiscal_item b ON a.id_docfiscal = b.id_docfiscal 
        LEFT JOIN usuario c ON a.id_usuario = c.id_usuario
        LEFT JOIN entidade d ON c.id_entidade = d.id_entidade
        LEFT JOIN entidade e ON b.id_vendedor = e.id_entidade
        LEFT JOIN item f ON b.id_item = f.id_item
        LEFT JOIN grupoitem g ON f.id_grupoitem = g.id_grupoitem 
        LEFT JOIN empresa h ON a.id_filial = h.id_empresa
            WHERE a.ch_situac = 'F'
            AND a.ch_sitpdv = 'F'
            AND a.ch_tipo <> 'NFE'
            AND b.ch_excluido IS NULL

    {IF PARAM_Emissao_ini} AND a.dt_emissa BETWEEN :emissao_ini AND :emissao_fim {ENDIF}

        GROUP BY 1,2,3,4,5
        ORDER BY 1,3,5


) x

{IF PARAM_Empresa} WHERE x.empresa IN (:Empresa) {ENDIF}
{IF PARAM_Vendedor} AND x.cod IN (:Vendedor) {ENDIF}