SELECT
    SUM(a.vl_valor) AS SALDO_INICIAL
FROM lanc a 
LEFT JOIN entidade b ON a.id_entidade = b.id_entidade
LEFT JOIN empresa c ON a.id_filial = c.id_empresa
    WHERE a.id_planoconta = '160-1'
    AND a.id_especie = '4-1'
    AND a.ch_excluido IS NULL 
    AND a.ch_debcre = 'C'
    AND a.id_tipolanc <> '83-1'
    AND a.ch_situac = 'A'

{IF PARAM_Empresa} AND a.id_filial IN (CASE
                                            WHEN c.ch_vinculada = 'T' THEN c.id_filial
                                            ELSE (:Empresa) END) {ENDIF}
{IF PARAM_Entidade} AND a.id_entidade IN (:Entidade) {ENDIF}
    