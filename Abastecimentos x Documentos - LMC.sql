SELECT
    x.emp,
    x.empresa,
    x.item,
    cf.descricao,
    x.data_abast,
    ab.qt_abast_t,
    ab.lt_abast_t,
    x.qt_abast,
    x.lt_abast,
    cf.qt_abast_cf,
    cf.lt_cupom,
    af.qt_abast_afe,
    af.lt_afericao,
    p.qt_abast_p,
    p.lt_abast_p,
    CAST(((x.lt_abast + af.lt_afericao) - cf.lt_cupom) AS NUMERIC(25,3)) AS DIF
FROM (
        SELECT
            a.id_empresa AS EMP,
            e.ds_empresa AS EMPRESA,
            a.id_item AS ITEM,
            CAST(a.dt_emissao AS DATE) AS DATA_ABAST,
            COUNT(a.id_abastecimento) AS QT_ABAST,
            CAST(SUM(a.qt_abastecimento) AS NUMERIC(25,3)) AS LT_ABAST
        FROM abastecimento a
        LEFT JOIN empresa e ON a.id_empresa = e.id_empresa
            WHERE a.ch_excluido IS NULL
            AND a.ch_ativo = 'T'
            AND a.ch_situac = 'B'
            AND a.id_item IN ( SELECT id_item FROM item WHERE ch_excluido IS NULL AND ch_ativo = 'T' AND ch_combustivel = 'T' )
            AND a.id_abastecimento NOT IN ( SELECT ad.id_abastecimento FROM afericao_det ad
                                            LEFT JOIN afericao af ON ad.id_afericao = af.id_afericao
                                                WHERE ad.ch_excluido IS NULL
                                                AND af.ch_excluido IS NULL )
            AND e.id_empresa IN (:Empresa)
            AND a.id_item IN (:Item)
            AND CAST(a.dt_emissao AS DATE) IN (:Data_Referencia)

        GROUP BY 1,2,3,4

) x,

    (
        SELECT
            d.id_filial AS EMP2,
            di.id_item AS ITEM2,
            di.ds_item AS DESCRICAO,
            CAST(d.dh_emissa AS DATE) AS DATA_CF,
            COUNT(di.id_abastecimento) AS QT_ABAST_CF,
            SUM(di.qt_item) AS LT_CUPOM
        FROM docfiscal d
        LEFT JOIN docfiscal_item di ON d.id_docfiscal = di.id_docfiscal
            WHERE d.id_filial IN (:Empresa)
            AND di.id_item IN (:Item)
            AND d.dh_emissa BETWEEN CAST((:Data_Referencia || ' 00:00:01') AS TIMESTAMP) AND CAST((:Data_Referencia || ' 23:59:59') AS TIMESTAMP)
            AND di.ch_excluido IS NULL
            AND d.ch_excluido IS NULL
            AND di.id_abastecimento IS NOT NULL
            AND d.ch_situac = 'F' 
            AND d.ch_sitpdv NOT IN ('C','A')
            AND d.ch_movest = 'T'
            AND di.id_item IN ( SELECT id_item FROM item WHERE ch_excluido IS NULL AND ch_ativo = 'T' AND ch_combustivel = 'T' )

        GROUP BY 1,2,3,4

) cf,

    (
        SELECT
            afe.id_filial AS EMP3,
            a.id_item AS ITEM3,
            COUNT(a.id_abastecimento) AS QT_ABAST_AFE,
            SUM(a.qt_abastecimento) AS LT_AFERICAO
        FROM afericao_det ad
        LEFT JOIN afericao afe ON ad.id_afericao = afe.id_afericao
        LEFT JOIN abastecimento a ON ad.id_abastecimento = a.id_abastecimento
            WHERE ad.ch_excluido IS NULL
            AND afe.ch_excluido IS NULL
            AND afe.id_filial IN (:Empresa)
            AND a.id_item IN (:Item)
            AND CAST(afe.dh_afericao AS DATE) IN (:Data_Referencia)

        GROUP BY 1,2

) af,

    (
        SELECT
            a.id_empresa AS EMP4,
            a.id_item AS ITEM4,
            COUNT(a.id_abastecimento) AS QT_ABAST_P,
            CAST(SUM(a.qt_abastecimento) AS NUMERIC(25,3)) AS LT_ABAST_P
        FROM abastecimento a
        LEFT JOIN empresa e ON a.id_empresa = e.id_empresa
            WHERE a.ch_excluido IS NULL
            AND a.ch_ativo = 'T'
            AND a.ch_situac = 'P'
            AND a.id_item IN ( SELECT id_item FROM item WHERE ch_excluido IS NULL AND ch_ativo = 'T' AND ch_combustivel = 'T' )
            AND e.id_empresa IN (:Empresa)
            AND a.id_item IN (:Item)
            AND CAST(a.dt_emissao AS DATE) IN (:Data_Referencia)

        GROUP BY 1,2

) p,

    (
        SELECT
            a.id_empresa AS EMP5,
            a.id_item AS ITEM5,
            CAST(a.dt_emissao AS DATE) AS DATA_ABAST_T,
            COUNT(a.id_abastecimento) AS QT_ABAST_T,
            CAST(SUM(a.qt_abastecimento) AS NUMERIC(25,3)) AS LT_ABAST_T
        FROM abastecimento a
        LEFT JOIN empresa e ON a.id_empresa = e.id_empresa
            WHERE a.ch_excluido IS NULL
            AND a.ch_ativo = 'T'
            AND a.id_item IN ( SELECT id_item FROM item WHERE ch_excluido IS NULL AND ch_ativo = 'T' AND ch_combustivel = 'T' )
            AND e.id_empresa IN (:Empresa)
            AND a.id_item IN (:Item)
            AND CAST(a.dt_emissao AS DATE) IN (:Data_Referencia)

        GROUP BY 1,2,3

) ab

    WHERE x.emp = cf.emp2
    AND cf.emp2 = af.emp3
    AND af.emp3 = p.emp4
    AND p.emp4 = ab.emp5
    AND x.item = cf.item2
    AND cf.item2 = af.item3
    AND p.item4 = ab.item5