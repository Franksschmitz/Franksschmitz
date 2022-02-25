select
    'ATIVO' as SITUACAO,
    b.ds_mot as MOTORISTA,
    b.ds_cpf as CPF,
    case
        when b.ch_motorista = null then 'CONVENIADO'
        when b.ch_conveniado = null then 'MOTORISTA'
        else 'MOTORISTA E CONVENIADO'
    end as TIPO
from entidade a 
left join entidade_mot b on a.id_entidade = b.id_entidade 
    where a.ch_ativo = 'T'
    and b.ch_ativo = 'T'
    and a.ch_excluido is null
    and b.ch_excluido is null
    and b.id_entidade_mot not in ( select id_entidade_mot from entidade_limven 
                                    where ch_excluido is null 
                                    and ch_tipo = 'M'
                                    and id_entidade = a.id_entidade )
                                        
{if param_Entidade} and a.id_entidade in (:Entidade) {endif}