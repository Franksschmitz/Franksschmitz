SELECT
    d.id_filial AS EMPRESA,
    a.dt_venda AS VENDA,
    a.hr_venda AS HORA,
    a.dt_pag AS DATA_PAGTO,
    a.id_cartaotef,
    b.ds_cartaotef AS CARTAO,
    a.id_operatef,
    c.ds_operatef AS OPERADORA,
    a.nr_autorizacao AS AUTORIZACAO,
    a.nr_nsu AS NSU,
    a.vl_total AS VALOR,
    a.vl_saldo_receber AS SALDO,
    a.per_taxa_cont AS TAXA_CONT,
    a.vl_taxa_cont AS VL_TAXA_CONT,
    a.vl_pertaxa AS TAXA_APL,
    a.vl_taxa AS VL_TAXA_APL,
    a.vl_recebido AS RECEBIDO
FROM conciliacao_movi a
LEFT JOIN cartaotef b ON a.id_cartaotef = b.id_cartaotef
LEFT JOIN operatef c ON a.id_operatef = c.id_operatef
LEFT JOIN conciliacao d ON a.id_conciliacao = d.id_conciliacao
    WHERE a.per_taxa_cont <> a.vl_pertaxa
    AND a.vl_taxa_cont <> a.vl_taxa
    AND a.ch_excluido IS NULL
    AND d.ch_excluido IS NULL
    AND a.id_cartaotef <> '1-1'
    
{IF PARAM_Empresa} AND d.id_filial IN (:Empresa) {ENDIF}
{IF PARAM_Operador} AND a.id_operatef IN (:Operadora) {ENDIF}
{IF PARAM_Cartao} AND a.id_cartaotef IN (:Cartao) {ENDIF}
{IF PARAM_Emissao_ini} AND a.dt_pag BETWEEN :Emissao_ini AND :Emissao_fim {ENDIF}

ORDER BY 9,7,2,3
