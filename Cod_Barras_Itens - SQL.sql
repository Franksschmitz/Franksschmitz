 select
  e.id_filial,
  d.id_item as "Codigo",
  a.ds_item as "Item",
  d.id_localarm as "Cod_Dep",
  e.ds_localarm as "Deposito",
  c.ds_grupoitem as "Grupo",
  d.qt_estoque as "Estoque",
  a.nr_codbar as "Cod_Barras",
  case
	when b.ch_excluido = 'T'   then a.nr_codbar 
	when b.ch_excluido = 'F'   then b.nr_codbar
	when b.ch_excluido is null then b.nr_codbar
  end as "Cod_Barras_Adc"
from item a
left join item_codbar b on (a.id_item = b.id_item)
left join grupoitem c on (a.id_grupoitem = c.id_grupoitem)
left join localarm_item d on (a.id_item = d.id_item)
left join localarm e on (d.id_localarm = e.id_localarm)
 where a.ch_revenda = 'T'
 and a.ch_ativo = 'T'
 and a.ch_excluido is null
 and d.qt_estoque > 0

    {if param_empresa} and e.id_filial in (:Empresa){endif}
	{if param_deposito} and d.id_localarm in (:LocalArmazenagem) {endif}
    {if param_grupoitem} and a.id_grupoitem in (:GrupoItem){endif}
    {if param_item} and a.id_item in (:Item){endif}
group by 2,1,3,4,5,6,7,8	
order by 3