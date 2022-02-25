-- DADOS DA ENTIDADE E DO MOTORISTA

select 
   pv.dt_emissa,
   pv.hr_emissa,
   pv.nr_ident as "Numero",
   pv.id_entidade as "Código",
   e.ds_entidade as "Cliente",
   pv.ds_mot,
   f.ds_codarea,
   f.ds_fone,
   f.ds_codareacel,
   f.ds_celular as "Celular"
from prevenda pv
left join prevenda_item pvi on (pv.id_prevenda = pvi.id_prevenda)
left join item i on (pvi.id_item = i.id_item)
left join entidade e on (pv.id_entidade = e.id_entidade)
left join entidade_contato f on (f.id_entidade = e.id_entidade)
    where pv.ch_excluido is null 
    and pvi.ch_excluido is null
    and pv.id_prevenda in (:id)


-- PRODUTOS DA COMANDA

select 
   pvi.id_item as "Item",
   i.ds_item as "Descrição",
   pvi.QT_ITEM as "QTD",
   pvi.VL_DESCON as "Desconto",
   pvi.VL_ACRES as "Acrescimo",
   pvi.VL_UNITAR as "Valor_Unitario",
   pvi.VL_TOTAL as "Total" 
from prevenda pv
left join prevenda_item pvi on (pv.id_prevenda = pvi.id_prevenda)
left join item i on (pvi.id_item = i.id_item)
left join entidade e on (pv.id_entidade = e.id_entidade)
left join entidade_contato f on (f.id_entidade = e.id_entidade)
    where pv.ch_excluido is null 
    and pvi.ch_excluido is null
    and pv.id_prevenda in (:id)

order by 2