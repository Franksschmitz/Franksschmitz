select
    x.empresa,
	x.cod,
	x.vendedor,
	x.codigo,
	x.item,
	x.id_grupo,
	x.grupo,
	x.qtd,
	x.base,
	x.percentual,
	x.comissao
from (
			select
				case 
				   when emp.ch_vinculada = 'T' then emp.id_filial
				   else e.id_filial
				end EMPRESA,
				dic.id_entidade COD,
				f.ds_entidade VENDEDOR,
				a.id_item CODIGO,
				b.ds_item ITEM,
				dic.id_regracomiss_apl,
				d.id_grupoitem ID_GRUPO,
				d.ds_grupoitem GRUPO,
				sum(a.qt_item) QTD,
				sum(dic.vl_base) BASE,
				dic.per_fat PERCENTUAL,
				sum(dic.vl_fat) COMISSAO
			from docfiscal_item_comiss dic 
			left join docfiscal_item a on (dic.id_docfiscal_item = a.id_docfiscal_item)
			left join docfiscal e on (a.id_docfiscal = e.id_docfiscal)
			left join item b on (a.id_item = b.id_item)
			left join grupoitem d on (b.id_grupoitem = d.id_grupoitem)
			left join entidade f on (dic.id_entidade = f.id_entidade)
			left join empresa emp on (e.id_filial = emp.id_empresa)
			left join regracomiss_apl ra on (dic.id_regracomiss_apl = ra.id_regracomiss_apl)
				where e.ch_situac = 'F'
				and e.ch_sitpdv = 'F'
				and dic.per_fat = cast(:Percentual as numeric(10,2))
				and a.ch_excluido is null
				and dic.ch_excluido is null
				and ra.ch_excluido is null
				and ra.ch_base = 'L'
 
				
			{if param_empresa} and case 
										when emp.ch_vinculada = 'T'  then emp.id_filial =:Empresa   
										when emp.ch_vinculada <> 'T' then e.id_filial =:Empresa end {endif}
			{if param_vendedor} and f.id_entidade in (:Vendedor) {endif}
			{if param_grupoitem} and d.id_grupoitem in (:GrupoItem) {endif}
			{if param_item} and b.id_item in (:Item) {endif}
			{if param_emissao_ini} and e.dh_emissa between :emissao_ini and :emissao_fim {endif}
			
			group by 1,2,3,4,5,6,7,8,11
			order by 1,3,5			


) x

