SELECT 
    b.id_filial,
    CASE
        WHEN b.id_filial IS NULL THEN 'GERAL'
        ELSE e.ds_empresa
    END AS EMPRESA,
    a.id_cartaotef,
    a.ds_cartaotef,
    c.id_operatef,
    c.ds_operatef AS OPERADORA,
    CASE 
        WHEN b.ch_padrao_pos = 'T' THEN 'SIM'
        ELSE 'NÃO'
    END AS PADRAO_POS,
    CASE
        WHEN b.qt_diavenc = '1' THEN b.qt_diavenc || ' ' || 'dia'
        WHEN b.qt_diavenc > '1' THEN b.qt_diavenc || ' ' || 'dias'
        ELSE 'NÃO CONFIGURADO'
    END AS QT_VENC,
    b.vl_taxa_min AS VALOR_MIN,
    b.per_taxa AS TAXA,
    b.per_taxa_pos AS TAXA_POS,
    b.vl_tarifa AS TARIFA,
    b.vl_tarifa_pos AS TARIFA_POS
FROM cartaotef a
LEFT JOIN cartaotef_ope b ON a.id_cartaotef = b.id_cartaotef
LEFT JOIN operatef c ON b.id_operatef = c.id_operatef
LEFT JOIN empresa e ON b.id_filial = e.id_empresa
    WHERE a.ch_ativo = 'T'
    AND a.ch_excluido IS NULL
    AND b.ch_excluido IS NULL
    AND a.id_cartaotef <> '1-1'

{IF PARAM_Empresa} AND b.id_filial IN (:Empresa) {endif}
{IF PARAM_Operadora} AND b.id_operatef IN (:Operadora) {endif}
{IF PARAM_Cartao} AND b.id_cartaotef IN (:Cartao) {endif}

ORDER BY 4,6