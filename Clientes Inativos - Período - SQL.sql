SELECT
    e.id_entidade AS CODIGO, 
    e.ds_entidade AS ENTIDADE,
    ec.ds_contato AS CONTATO,
    ec.ds_email AS EMAIL,
    ec.ds_codarea AS COD,
    ec.ds_fone AS TELEFONE,
    ec.ds_codareacel AS CODCEL,
    ec.ds_celular AS CELULAR
FROM entidade e
LEFT JOIN entidade_endereco ee ON (e.id_entidade = ee.id_entidade)
left join entidade_contato ec ON (e.id_entidade = ec.id_entidade)
left join grupoentidade ge ON (e.id_grupoentidade = ge.id_grupoentidade)
    WHERE ee.ch_principal = 'T'
    AND e.ch_excluido IS NULL
    AND e.ch_ativo = 'T'    
    AND e.id_entidade NOT IN (
                                    SELECT d.id_entidade FROM docfiscal d
                                    LEFT JOIN docfiscal_item di ON (d.id_docfiscal = di.id_docfiscal)
                                    LEFT JOIN item i ON (di.id_item = i.id_item)
                                        WHERE d.ch_excluido IS NULL
                                        AND d.ch_situac = 'F'
                                        AND d.ch_tipo <> 'VEN'
                                        AND d.ch_gerarecpag = 'T'
                                        AND d.ch_operac = 'S'
                                        AND di.ch_excluido IS NULL

                                    {IF param_Empresa} AND d.id_filial IN (:Empresa) {ENDIF}
                                    {IF param_GrupoItem} AND i.id_grupoitem IN (:GrupoItem) {ENDIF}
                                    {IF param_Item} AND di.id_item IN (:Item) {ENDIF}
                                    {IF param_Periodo} AND d.dt_emissa BETWEEN :Periodo AND :Ate {ENDIF}
                                )

{IF param_GrupoEntidade} AND e.id_grupoentidade IN (:GrupoEntidade) {ENDIF}
{IF param_Entidade} AND e.id_entidade IN (:Entidade) {ENDIF}

ORDER BY 2