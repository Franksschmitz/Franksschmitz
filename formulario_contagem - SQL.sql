select
  i.id_item as ID,
  i.nr_fantasia as CODIGO,
  i.ds_item as ITEM, 
  gi.ds_grupoitem as GRUPO,
  li.qt_estoque as ESTOQUE
from localarm_item li
left join item i on (li.id_item=i.id_item)
left join item_filial f on (i.id_item = f.id_item)
left join grupoitem gi on (gi.id_grupoitem=i.id_grupoitem)
  where li.id_item = f.id_item
  and li.id_localarm = f.id_localarm
  and li.ch_excluido is null
  and f.ch_excluido is null
  and i.ch_ativo='T'
 
  {if param_id_item} and i.id_item in (:id_item) {endif}
  {if param_id_localarm} and li.id_localarm in (:id_localarm) {endif}
  {if param_id_grupoitem} and gi.id_grupoitem in (:id_grupoitem) {endif}

  order by 4,3,5 