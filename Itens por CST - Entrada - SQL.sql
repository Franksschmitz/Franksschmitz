select
  a.id_item as "Codigo",
  a.ds_item as "Item",
  a.id_grupoitem as "Grupo",
  c.ds_grupoitem as "Descricao",
  z.ds_imposto as "Imposto",
  e.nr_cst as "CST",
  case
     when y.ch_aprcre = 'T' then 'SIM' 
     when y.ch_aprcre = 'F' then 'NÃO'
  end as "Ap Cred"
from item a
left join classfiscal b on a.id_classfiscal = b.id_classfiscal
left join grupoitem c on a.id_grupoitem = c.id_grupoitem
left join item_cfgfiscal f on a.id_item = f.id_item
left join cfgfiscal x on f.id_cfgfiscal = x.id_cfgfiscal
left join cfgfiscal_imposto d on f.id_cfgfiscal = d.id_cfgfiscal
left join cfgfiscal_impter y on x.id_cfgfiscal = y.id_cfgfiscal
left join cst e on y.id_cst = e.id_cst
left join imposto z on y.id_imposto = z.id_imposto
  where a.ch_ativo = 'T'
  and a.ch_excluido is null 
  and f.ch_excluido is null
  and x.ch_tipo = 'T'
    {if param_imposto} and z.id_imposto in (:Imposto){endif}
    {if param_cst} and e.nr_cst in (:CST) {endif}
    {if param_grupoitem} and c.id_grupoitem in (:GrupoItem){endif}
    {if param_item} and a.id_item in (:Item){endif}
group by 1,2,3,4,5,6,7
order by 2