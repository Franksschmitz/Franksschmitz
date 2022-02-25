-- Relatório de Comissões / Regras de aplicação por grupo.

select
   a.id_regracomiss as "Codigo",
   a.ds_regracomiss as "Descricao",
   b.id_grupoitem as "Codigo Grupo",
   c.ds_grupoitem as "Grupo",
   b.vl_fat as "Faturado",
   b.vl_liq as "Liquido"
from regracomiss as a
left join docfiscal_item_comiss as b on (a.id_regracomiss = b.id_regracomiss)
left join grupoitem as c on (b.id_grupoitem = c.id_grupoitem)
left join docfiscal as d on (b.id_entidade = d.id_entidade)
where a.ch_excluido is null
and a.ch_ativo = 'T'
and d.ch_situac = 'F'
and d.ch_sitpdv = 'F'
and b.id_regracomiss_apl is not null
    {if param_empresa} and a.id_filial in (:Empresa) {endif}
    {if param_id_grupoitem} and e.id_grupoitem in (:GrupoItem) {endif}
    {if param_id_regracomiss} and id_regracomiss in (:Regra){endif}
    {if param_emissao} and d.dt_emissa between :Emissao and :Ate {endif}    
group by 1,2,3,4,5,6
order by 3