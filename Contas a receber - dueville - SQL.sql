select 
    g.dt_emissa as "Data",
    a.id_filial as "Empresa",
    a.id_entidade as "Entidade",
    b.ds_entidade as "Nome",
    a.ds_historico as "Historico",
    a.dt_vencim as "Vencimento",
    a.vl_valor as "Valor",
    a.vl_juro as "Juros",
    a.vl_descon as "Desconto",
    a.vl_pago as "Total"
from lanc as a 
  left join entidade as b on (b.id_entidade = a.id_entidade)
  left join empresa as c on (c.id_filial = a.id_empresa)
  left join especie as d on (d.id_especie = a.id_especie)
  left join planoconta as e on (e.id_planoconta = a.id_planoconta)
  left join rectopagto as f on (f.id_rectopagto = a.id_rectopagto)
  left join rectopagto_baixa as g on (f.id_rectopagto = a.id_rectopagto)
where e.ch_cont_baixa = 'T'
and e.ch_cont_fin = 'R'
and a.ch_situac = 'L'
and d.ch_tipo in ('N','B')
and a.ch_excluido is null
    {if param_Empresa} and c.id_empresa in (:Empresa) {endif}
    {if param_Entidade} and b.id_entidade in (:Entidade) {endif}
    {if param_PlanoConta} and e.id_planoconta in (:PlanoConta) {endif}
    {if param_Especie} and d.id_Especie in (:Especie) {endif}
    {if param_Baixa} and a.dh_lanc between :Baixa and :Ate {endif}
group by 1,2,3,4,5,6,7,8,9,10
order by 1