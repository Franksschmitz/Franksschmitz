SELECT
    f.dt_doc AS EMISSAO,
    f.dt_vencim AS VENCIMENTO,
    f.nr_docume AS NR_CHEQUE,
    f.nr_agencia AS AGENCIA,
    f.nr_conta AS CONTA,
    f.vl_valor AS VALOR,
    g.nr_banco AS NR_BANCO,
    g.ds_sigla AS BANCO,
    f.ds_cpfcnpj AS CPFCNPJ,
    f.ds_titular AS TITULAR,
    d.id_planoconta,
    p.ds_planoconta AS CONTA_DEP,
    a.dt_emissa AS DATA_DEP
FROM compcheq a
LEFT JOIN compcheq_recpag b ON a.id_compcheq = b.id_compcheq
LEFT JOIN rectopagto c ON a.id_compcheq = c.id_compcheq
LEFT JOIN rectopagto_baixa d ON c.id_rectopagto = d.id_rectopagto
LEFT JOIN lanc e ON b.id_lanc = e.id_lanc
LEFT JOIN titulo f ON e.id_titulo_ref = f.id_titulo
LEFT JOIN banco g ON f.id_banco_t = g.id_banco
LEFT JOIN planoconta p ON d.id_planoconta = p.id_planoconta
    WHERE b.ch_excluido IS NULL
    AND a.id_compcheq IN (:id) 

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
ORDER BY 1,2
