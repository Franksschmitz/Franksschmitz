SELECT
    SUM(a.vl_valor) AS SALDO_INICIAL
FROM lanc a 
LEFT JOIN entidade b ON a.id_entidade = b.id_entidade
LEFT JOIN empresa c ON a.id_filial = c.id_empresa
    WHERE a.id_planoconta = '160-1'
    AND a.id_especie = '4-1'
    AND a.ch_excluido IS NULL 
    AND a.id_tipolanc <> '83-1'
    AND a.dh_lanc BETWEEN '2000-01-01 00:01' AND CAST(CAST(((:emissao_ini) || ' 00:01')AS VARCHAR(22)) AS TIMESTAMP)
    AND a.id_filial IN (CASE
                            WHEN c.ch_vinculada = 'T' THEN c.id_filial
                            ELSE (:Empresa) END)
    AND a.id_entidade IN (:Entidade)
    