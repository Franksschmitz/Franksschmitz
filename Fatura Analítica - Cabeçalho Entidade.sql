SELECT
    x.entidade,
    x.nome,
    x.cpfcnpj,
    x.dt_fatura,
    x.vencimento,
    x.nr_fatura,
    x.obs
FROM (

        SELECT 
            r.id_reparc,
            r.id_entidade AS ENTIDADE,
            e.ds_razao AS NOME,
            e.ds_cpfcnpj AS CPFCNPJ,
            e.ds_obsfaturas AS OBS,
            g.dt_emissa AS DT_FATURA,
            l.dt_vencim AS VENCIMENTO,
            l.nr_docume AS NR_FATURA
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
            AND l.ch_debcre = 'D'
            AND r.id_reparc IN (:ID)

) x

GROUP BY 1,2,3,4,5,6,7