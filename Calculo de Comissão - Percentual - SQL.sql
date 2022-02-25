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
	cast(((x.base * x.percentual) / 100) as numeric(20,2)) COMISSAO
from (
            select
				e.id_filial EMPRESA,
				dic.id_entidade COD,
				f.ds_entidade VENDEDOR,
				a.id_item CODIGO,
				b.ds_item ITEM,
				dic.id_regracomiss_apl,
				d.id_grupoitem ID_GRUPO,
				d.ds_grupoitem GRUPO,
				sum(a.qt_item) QTD,
				sum(dic.vl_base) BASE,
				cast((:Percentual) as numeric(20,2)) as PERCENTUAL
			from docfiscal_item_comiss dic 
			left join docfiscal_item a on (dic.id_docfiscal_item = a.id_docfiscal_item)
			left join docfiscal e on (a.id_docfiscal = e.id_docfiscal)
			left join item b on (a.id_item = b.id_item)
			left join grupoitem d on (b.id_grupoitem = d.id_grupoitem)
			left join entidade f on (dic.id_entidade = f.id_entidade)
			join empresa emp on (e.id_filial = emp.id_empresa)
				where e.ch_situac = 'F'
				and e.ch_sitpdv = 'F'
				and dic.id_regracomiss_apl is not null
				and a.ch_excluido is null
				and dic.ch_excluido is null
				
		    {if param_empresa} and e.id_filial in (:Empresa) {endif}
			{if param_vendedor} and f.id_entidade in (:Vendedor) {endif}
			{if param_grupoitem} and d.id_grupoitem in (:GrupoItem) {endif}
			{if param_item} and b.id_item in (:Item) {endif}
			{if param_emissao_ini} and e.dh_emissa between :emissao_ini and :emissao_fim {endif}
			
			group by 1,2,3,4,5,6,7,8,11
			order by 1,3,5			
) x
