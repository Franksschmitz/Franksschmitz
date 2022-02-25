SELECT 
    x.nr_doc,
    x.emissao,
    x.tipo,
    x.valor,
    CASE 
        WHEN x.situac = 'A' THEN 'Documento Autorizado'
        WHEN x.situac = 'C' THEN 'Documento Cancelado'
        WHEN x.situac = 'D' THEN 'Uso Denegado'
        WHEN x.situac = 'I' THEN 'Documento Inutilizado'
        WHEN x.situac = 'R' THEN 'Documento Rejeitado'
    END AS SITUACAO,
    x.chave
FROM (
        SELECT
            d.nr_docfiscal AS NR_DOC,
            d.dt_emissa AS EMISSAO,
            d.ch_tipo AS TIPO,
            d.vl_total AS VALOR,
            de.ch_sitnfe AS SITUAC,
            de.ds_chave AS CHAVE
        FROM docfiscal d 
        LEFT JOIN docfiscal_eletro de ON d.id_docfiscal = de.id_docfiscal
            WHERE d.ch_excluido IS NULL
            AND de.ch_excluido IS NULL

{IF PARAM_Empresa} AND d.id_filial IN (:Empresa) {ENDIF}
{IF PARAM_Tipo} AND d.ch_tipo IN ( CASE
                                        WHEN (:Tipo) = 'NFCE'   THEN 'NFCE'
                                        WHEN (:Tipo) = 'nfce'   THEN 'NFCE'
                                        WHEN (:Tipo) = 'NFCe'   THEN 'NFCE'
                                        WHEN (:Tipo) = 'NFC-e'  THEN 'NFCE'
                                        WHEN (:Tipo) = 'NFC-E'  THEN 'NFCE'
                                        WHEN (:Tipo) = 'nfc-e'  THEN 'NFCE'
                                        WHEN (:Tipo) = 'NFE'    THEN 'NFE'
                                        WHEN (:Tipo) = 'nfe'    THEN 'NFE'
                                        WHEN (:Tipo) = 'NFe'    THEN 'NFE'
                                        WHEN (:Tipo) = 'NF-e'   THEN 'NFE'
                                        WHEN (:Tipo) = 'NF-E'   THEN 'NFE'
                                        WHEN (:Tipo) = 'nf-e'   THEN 'NFE'
                                        WHEN (:Tipo) = 'sat'   THEN 'CFE'
                                        WHEN (:Tipo) = 'cfe'   THEN 'CFE'
                                        WHEN (:Tipo) = 'SAT'   THEN 'CFE'
                                        WHEN (:Tipo) = 'CFE'   THEN 'CFE'
                                        WHEN (:Tipo) = 'CF-E'   THEN 'CFE'
                                        WHEN (:Tipo) = 'cf-e'   THEN 'CFE'
                                    END ) {ENDIF}
{IF PARAM_Situacao} AND d.ch_situac IN ( CASE
                                            WHEN (:Situacao) = 'A' THEN 'F'
                                            WHEN (:Situacao) = 'C' THEN 'C'
                                            WHEN (:Situacao) = 'I' THEN 'C'
                                            WHEN (:Situacao) = 'D' THEN 'C'
                                            WHEN (:Situacao) = 'R' THEN 'F'
                                            WHEN (:Situacao) = 'a' THEN 'F'
                                            WHEN (:Situacao) = 'c' THEN 'C'
                                            WHEN (:Situacao) = 'i' THEN 'C'
                                            WHEN (:Situacao) = 'd' THEN 'C'
                                            WHEN (:Situacao) = 'r' THEN 'F'
                                         END ) {ENDIF}
{IF PARAM_Situacao} AND de.ch_sitnfe IN ( CASE
                                            WHEN (:Situacao) = 'A' THEN 'A'
                                            WHEN (:Situacao) = 'C' THEN 'C'
                                            WHEN (:Situacao) = 'I' THEN 'I'
                                            WHEN (:Situacao) = 'D' THEN 'D'
                                            WHEN (:Situacao) = 'R' THEN 'R'
                                            WHEN (:Situacao) = 'a' THEN 'A'
                                            WHEN (:Situacao) = 'c' THEN 'C'
                                            WHEN (:Situacao) = 'i' THEN 'I'
                                            WHEN (:Situacao) = 'd' THEN 'D'
                                            WHEN (:Situacao) = 'r' THEN 'R'
                                          END ) {ENDIF}
{IF PARAM_emissao_ini} AND d.dt_emissa BETWEEN :emissao_ini AND :emissao_fim {ENDIF}

) x

ORDER BY 1