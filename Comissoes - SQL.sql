select
    x.empresa,
	x.cod,
	x.vend,
	x.codigo,
	x.item,
	x.grupo,
	x.qtd,
	x.valor,
	x.apl,
	x.fat,
	case
	   when x.apl = 'P' then cast((x.valor * x.fat)as numeric(10,2))
	   when x.apl = 'V' then (x.qtd * x.fat)
	end as COM
from (
			select
			   e.id_filial as EMPRESA,
			   a.id_vendedor as COD,
			   f.ds_entidade as VEND,
			   a.id_item as CODIGO,
			   b.ds_item as ITEM,
			   d.ds_grupoitem as GRUPO,
			   sum(a.qt_item) as QTD,
			   sum(a.vl_total) as VALOR,
			   c.ch_aplicar as APL,
			   case
                  when a.id_item in ('31-5','32-5','33-5','34-5','35-5','37-5','38-5','39-5','40-5','41-5','42-5',) then cast(('0.025')as numeric(5,3))
				  else cast(('0.075')as numeric(5,3))
			   end as FAT  
			from docfiscal_item a 
			left join docfiscal e on (a.id_docfiscal = e.id_docfiscal)
			left join item b on (a.id_item = b.id_item)
			left join regracomiss_apl c on (b.id_grupoitem = c.id_grupoitem)
			left join grupoitem d on (b.id_grupoitem = d.id_grupoitem)
			left join entidade f on (a.id_vendedor = f.id_entidade)
			where e.ch_situac = 'F'
			and e.ch_sitpdv = 'F'
			and b.id_grupoitem in ('2-5','3-5','4-5') or a.id_item = c.id_item
			and c.ch_excluido is null
			and a.ch_excluido is null
			
			{if param_empresa} and e.id_filial in (:Empresa) {endif}
			{if param_vendedor} and f.id_entidade in (:Vendedor) {endif}
			{if param_grupoitem} and d.id_grupoitem in (:GrupoItem) {endif}
			{if param_item} and b.id_item in (:Item) {endif}
			{if param_emissao_ini} and e.dh_emissa between :emissao_ini and :emissao_fim {endif}
			
			group by 1,2,3,4,5,6,9,10
			order by 1,3,5


) x

