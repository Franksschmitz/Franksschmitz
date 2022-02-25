select 
	emp.DS_EMPRESA as DS_AGRUPADOR,
	lote.ID_LOTEITEM,
	i.ID_ITEM,
	i.DS_ITEM,
	lote.NR_LOTE,
	cast(lote.DH_LOTE as date) as DT_LOTE,
	lote.DT_VALIDADE,
	lote.QT_LOTE,
	lote.QT_BAIXADA,
	lote.QT_DISPONIVEL  
from ITEM i
left join LOCALARM_ITEM li on li.ID_ITEM = i.ID_ITEM
left join LOCALARM l on l.ID_LOCALARM = li.ID_LOCALARM
left join EMPRESA emp on emp.ID_EMPRESA = l.ID_FILIAL
left join GRUPOITEM gi on gi.ID_GRUPOITEM = i.ID_GRUPOITEM 
join PROC_LOTES_DISPONIVEIS_ITEM(i.ID_ITEM, l.ID_LOCALARM, :DH_STATUS) lote on true      
order by DS_AGRUPADOR, i.DS_ITEM, lote.DT_VALIDADE