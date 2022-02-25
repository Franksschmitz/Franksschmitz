select
     x.id,
	 x.empresa,
	 x.codigo,
	 x.item,
	 x.quantidade,
	 cast((x.quantidade * x.vl) as numeric (22,2)) VALOR
from (
			select
				 d.id_filial as ID,
				 g.ds_empresa as EMPRESA,
				 di.id_item as CODIGO,
				 di.ds_item as ITEM,
				 di.vl_unitar as VL,
				 di.qt_item as QUANTIDADE
			from cartao_mov cm 
			left join docfiscal d on (cm.id_docfiscal = d.id_docfiscal)
			left join docfiscal_item di on (d.id_docfiscal_item = di.id_docfiscal_item)
			left join empresa g on (d.id_filial = g.id_empresa)
				where cm.ch_tipo = 'R'
				and d.ch_excluido is null
				and di.ch_excluido is null 
				and cm.ch_excluido is null
				
			{if param_id_filial} and d.id_filial in (:id_filial) {endif}
			{if param_id_item} and di.id_item in (:id_item) {endif}
			{if param_emissao_ini} and d.dt_emissa between :emissao_ini and :emissao_fim {endif}

) x

group by 1,3,2,4,5,6
order by 1,5 desc