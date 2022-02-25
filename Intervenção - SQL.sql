select
   a.dt_intervencao as "Data",
   a.id_empresa as "Empresa",
   c.id_item as "Codigo",
   c.ds_item as "Item",
   b.id_bico as "Id",
   b.ds_bico as "Bico",
   b.nr_bico as "Nr Bico",
   a.qt_var_ence as "Litros",
   a.qt_ence_ant as "Enc Inicial",
   a.qt_ence_nov as "Enc Final"
from intervencao as a
left join bico as b on (b.id_bico = a.id_bico)
left join item as c on (c.id_item = b.id_item)
where a.ch_excluido is null
   {if param_Empresa} and a.id_empresa in (:Empresa){endif}
   {if param_Item} and c.id_item in (:Item){endif}
   {if param_Bico} and b.id_bico in (:Bico){endif}
   {if param_Emissao} and a.dt_intervencao between :Emissao and :Ate {endif}