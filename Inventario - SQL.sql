select 
   a.dh_leitura as "DataHora",
   a.id_invent as "Inventario",
   b.id_item as "Codigo", 
   b.ds_item as "Descricao", 
   a.qt_item as "Item", 
   a.qt_estoque as "Atual", 
   a.qt_disponivel as "Disponivel", 
   a.qt_leitura as "Leitura"
from invent_item as a
left join item as b on (a.id_item = b.id_item)
left join invent as c on (a.id_invent = c.id_invent)
where a.ch_excluido is null
{if param_empresa} and c.id_filial in (:Empresa) {endif}
{if param_invent} and a.id_invent in (:Inventario) {endif}
{if param_emissao} and c.dt_emissa between :Emissao and :Ate {endif}
order by 1
