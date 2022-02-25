SELECT
    x.*
FROM (

        SELECT
            CASE
                WHEN e.ch_vinculada = 'T' THEN e.id_filial
                ELSE a.id_empresa
            END AS EMPRESA,
            EXTRACT(HOUR FROM a.dt_emissao) AS HORA,
            COUNT(a.id_abastecimento) AS QUANT,
            SUM(a.qt_abastecimento) AS LITROS
        FROM abastecimento a
        LEFT JOIN empresa e ON (a.id_empresa = e.id_empresa)
            WHERE a.ch_excluido IS NULL
            AND a.ch_ativo = 'T'

        {IF param_Bico} AND a.id_bico IN (:Bico) {ENDIF}
        {IF param_Item} AND a.id_item IN (:Item) {ENDIF}
        {IF param_emissao_ini} AND CAST(a.dt_emissao AS DATE) BETWEEN :emissao_ini AND :emissao_fim {ENDIF}

        GROUP BY 1,2
        ORDER BY 2 DESC

) x

{IF param_Empresa} WHERE x.empresa IN (:Empresa) {ENDIF}

GROUP BY 1,2,3,4
ORDER BY 1,2 DESC
