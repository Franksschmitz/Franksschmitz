select
  b.id_grupoitem as "Cod Grupo",
  b.ds_grupoitem as "Grupo",
  a.id_item as "Codigo",
  a.ds_item as "Item",
  a.nr_codbar as "Cod Barras",
  d.qt_estoque as "Estoque"
from item a
left join grupoitem as b on (a.id_grupoitem = b.id_grupoitem)
left join movest_item as c on (a.id_item = c.id_item)
left join localarm_item as d on (a.id_item = d.id_item)
left join localarm e on (d.id_localarm = e.id_localarm)
where a.ch_ativo = 'T'
and a.ch_excluido is null
and c.ch_excluido is null
and c.id_docfiscal_item is null
and c.id_invent_item is null
and d.qt_estoque <> 0
and a.ch_combustivel = 'F'
and c.id_filial = e.id_filial

   {if param_empresa} and c.id_filial in (:Empresa) {endif}
   {if param_grupoitem} and b.id_grupoitem in (:GrupoItem) {endif}
   {if param_emissao} and c.dt_movime between :Inicio and :Fim {endif}
   
group by 1,2,3,4,5,6
order by 4