select
  a.id_item as "Codigo",
  a.ds_item as "Item",
  a.id_grupoitem as "Grupo",
  c.ds_grupoitem as "Descricao",
  b.nr_ncm as "NCM" 
from item a
left join classfiscal b on b.id_classfiscal = a.id_classfiscal
left join grupoitem c on c.id_grupoitem = a.id_grupoitem
where b.id_classfiscal in 
    ( 
      select id_classfiscal from item
      where ch_ativo = 'T'
      and ch_excluido is null
         )
and a.ch_combustivel = 'F'
    {if param_grupoitem} and a.id_grupoitem in (:GrupoItem){endif}
    {if param_item} and a.id_item in (:Item){endif}
order by 5,2