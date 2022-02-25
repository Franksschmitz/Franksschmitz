select
    'ATIVO' as SITUACAO,
    b.ds_veic as VEICULO,
    case
        when b.ds_placa is null then 'NÃO PREENCHIDO'
        when b.ds_placa = null then 'NÃO PREENCHIDO'
        else b.ds_placa
    end as PLACA,
    case
        when b.ds_renavam = '0' then 'NÃO PREENCHIDO'
        when b.ds_renavam = null then 'NÃO PREENCHIDO'
        when b.ds_renavam is null then 'NÃO PREENCHIDO'
        else b.ds_renavam
    end as RENAVAM,
    case
        when cast(b.nr_frota as varchar(25)) = '0' then 'NÃO PREENCHIDO'
        when cast(b.nr_frota as varchar(25)) = null then 'NÃO PREENCHIDO'
        when cast(b.nr_frota as varchar(25))is null then 'NÃO PREENCHIDO'
        else cast(b.nr_frota as varchar(25))
    end as FROTA
from entidade a 
left join entidade_veic b on a.id_entidade = b.id_entidade 
    where a.ch_ativo = 'T'
    and b.ch_ativo = 'T'
    and a.ch_excluido is null
    and b.ch_excluido is null
    and id_entidade_veic not in ( select id_entidade_veic from entidade_limven 
                                    where ch_excluido is null
                                    and ch_tipo = 'V'
                                    and id_entidade = a.id_entidade )

{if param_Entidade} and a.id_entidade in (:Entidade) {endif}