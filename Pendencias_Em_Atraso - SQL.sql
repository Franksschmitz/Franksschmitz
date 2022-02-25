select
    a.id_entidade as "Entidade",
    d.ds_titular as "Titular",
    a.dt_doc as "Emissao",
    a.dt_vencim as "Vencimento",
    a.nr_docume as "Documento",
    b.ds_planoconta as "Conta",
    a.vl_valor as "Valor",
    a.vl_saldo as "Saldo",
    (current_date - a.dt_vencim) as "Dias Atraso"
from lanc as a
  left join planoconta as b on (a.id_planoconta = b.id_planoconta)
  left join titulo as d on (a.id_lanc = d.id_lanc)
where a.dt_vencim <= current_date 
and a.ch_excluido is null
and a.ch_ativo = 'T' 
and a.ch_situac = 'A'
and a.id_especie in ('3-1','8-1')
  {if param_empresa} and a.id_filial in (:Empresa) {endif}
  {if param_plano_conta} and b.id_planoconta in (:Plano Conta) {endif}
  {if param_especie} and a.id_especie in (:Especie) {endif}
  {if param_emissao} and a.dt_doc between :Emissao and :Ate {endif}
order by 2 