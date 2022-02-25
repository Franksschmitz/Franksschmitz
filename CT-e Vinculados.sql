SELECT
    nf.id_filial AS NF_EMPRESA,
    nf.dt_saicheg AS NF_LANC,
    nf.id_entidade AS NF_CODFORNEC,
    f.ds_entidade AS NF_FORNEC,
    nf.ds_serie AS NF_SERIE,
    nf.nr_notafi AS NF_NOTA,
    nfct.id_filial AS CT_EMPRESA,
    nfct.dt_saicheg AS CT_LANC,
    nfct.id_entidade AS CT_CODTRANSP,
    t.ds_entidade AS CT_TRANSP,
    nfct.nr_notafi AS CT_NOTA,
    CASE
        WHEN ct.ch_tipofrete = 'D' THEN 'DESPACHO'
        ELSE 'REDESPACHO'
    END AS CT_TIPO,
    ct.vl_frete AS CT_FRETE
FROM nft_ctnf AS ct
LEFT JOIN nft AS nfct ON ct.id_nft = nfct.id_nft
LEFT JOIN entidade AS t ON nfct.id_entidade = t.id_entidade
LEFT JOIN nft AS nf ON ct.id_nft_ct = nf.id_nft
LEFT JOIN entidade AS f ON nf.id_entidade = f.id_entidade
    WHERE ct.ch_excluido IS NULL
    AND ct.id_nft_ct IS NOT NULL
    AND nfct.ch_excluido IS NULL
    AND nf.ch_excluido IS NULL

{IF PARAM_Empresa} AND nfct.id_filial IN (:Empresa) {ENDIF}
{IF PARAM_Transportadora} AND nfct.id_entidade IN (:Transportadora) {ENDIF}
{IF PARAM_NR_CTE} AND nfct.nr_notafi IN (:NR_CTE) {ENDIF}

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
ORDER BY 2