SELECT 
    rv.nr_voucher AS numero, 
    rp.dh_inicio AS inicio_validade, 
    rp.dh_fim AS fim_validade, 
    CASE
        WHEN rv.ch_utilizado = 'T' THEN 'UTILIZADO'
        WHEN rv.ch_utilizado = 'F' THEN 'NÃO UTILIZADO'
    END situacao
FROM regrapreco rp
LEFT JOIN regrapreco_voucher rv ON (rp.id_regrapreco = rv.id_regrapreco)
    where rp.ch_excluido IS NULL 
    AND rv.ch_excluido IS NULL
    AND rv.nr_voucher IS NOT NULL
    AND rp.ch_tipo = 'P'

{IF param_id_filial} AND rp.id_empresa IN (:Empresa) {ENDIF}
{IF param_id_regrapreco} AND rp.id_regrapreco IN (:Promocao) {ENDIF}
{IF param_Utilizado} AND CASE
                            WHEN ((:Utilizado) = 'S') THEN rv.ch_utilizado = 'T'
                            WHEN ((:Utilizado) = 'N') THEN rv.ch_utilizado = 'F'
                            WHEN ((:Utilizado) = 's') THEN rv.ch_utilizado = 'T'
                            WHEN ((:Utilizado) = 'n') THEN rv.ch_utilizado = 'F'
                         END {endif}

{IF param_ordem_Voucher} ORDER BY rv.nr_voucher {ENDIF}
{IF param_ordem_Situação} ORDER BY rv.ch_utilizado {ENDIF}