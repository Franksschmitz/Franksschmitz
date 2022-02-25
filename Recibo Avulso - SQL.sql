SELECT
    y.empresa,
    y.cpfcnpj_emp,
    y.ie_emp,
    x.nome,
    x.cpfcnpj,
    x.ie,
    x.doc,
    x.emissao,
    x.vencimento,
    x.valor,
    x.historico
FROM (
        SELECT
            (:Emissao) AS EMISSAO,
            (:Vencimento) AS VENCIMENTO,
            ds_entidade AS NOME,
            ds_cpfcnpj AS CPFCNPJ,
            CASE
                WHEN ds_ie = NULL THEN 'ISENTO'
                WHEN ds_ie = '' THEN 'ISENTO'
            END AS IE,
            (:Documento) AS DOC,
            (:Valor) AS VALOR,
            (:Historico) AS HISTORICO
        FROM entidade 
            WHERE id_entidade =:Entidade
) x,
    (
        SELECT
            ds_entidade AS EMPRESA,
            ds_cpfcnpj AS CPFCNPJ_EMP,
            ds_ie AS IE_EMP
        FROM entidade 
            WHERE id_entidade IN ( SELECT id_entidade FROM empresa WHERE id_empresa =:Empresa )

) y