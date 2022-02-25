SELECT
   a.dh_lanc AS DATAHORA,
   d.ds_empresa AS EMPRESA,
   b.ds_entidade AS NOME,
   b.ds_cpfcnpj AS CPFCNPJ,
   a.vl_valor AS VALOR,
   'LANÇAMENTO REF A FALTA DE CAIXA DO TURNO ' || (SELECT nr_turno FROM caixapdv WHERE id_caixapdv = a.id_caixapdv) AS HISTORICO
FROM lanc a
LEFT JOIN usuario u ON (a.id_usuario = u.id_usuario)
LEFT JOIN entidade b ON (u.id_entidade = b.id_entidade)
LEFT JOIN empresa d ON (a.id_empresa = d.id_empresa)
    WHERE a.id_lanc IN (:id)