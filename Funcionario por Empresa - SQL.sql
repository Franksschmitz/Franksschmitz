select
    a.id_entidade as CODIGO,
    a.ds_entidade as NOME,
    a.ds_cpfcnpj as CPFCNPJ,
    c.id_filial as EMPRESA,
    d.ds_empresa as DESCRICAO,
    e.id_grupoentidade,
    e.ds_grupoentidade as GRUPO
from entidade a
left join usuario b on (a.id_entidade = b.id_entidade)
left join usuario_filial c on (b.id_usuario = c.id_usuario)
left join empresa d on (c.id_filial = d.id_empresa)
left join grupoentidade e on (a.id_grupoentidade = e.id_grupoentidade)
    where a.ch_excluido is null
    and a.ch_ativo = 'T'
    and b.ch_ativo = 'T'
    and b.ch_excluido is null
    and c.ch_excluido is null
    and d.ch_excluido is null
    and e.ch_excluido is null

{if param_filial} and c.id_filial in (:Empresa) {endif}

order by 4,2