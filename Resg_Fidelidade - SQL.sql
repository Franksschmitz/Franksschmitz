select
	 d.id_filial as ID,
	 g.ds_empresa as EMPRESA,
	 d.dt_emissa as DATA,
	 d.nr_docfiscal as NR_DOC, 
	 d.id_entidade as ID_ENT, 
	 d.ds_entidade as ENTIDADE,
	 di.id_item as ID_ITEM,
	 di.ds_item as ITEM,
	 di.vl_unitar as VALOR,
	 di.qt_item as QTD,
	 di.vl_total as TOTAL,
	 cx.ds_caixacfg as CAIXA,
	 u.ds_nome as USUARIO
from cartao_mov cm 
left join docfiscal d on (d.id_docfiscal=cm.id_docfiscal)
left join docfiscal_item di on (d.id_docfiscal=di.id_docfiscal)
left join caixapdv cp on (d.id_caixapdv=cp.id_caixapdv)
left join caixacfg cx on (cp.id_caixacfg=cx.id_caixacfg)
left join usuario u on (u.id_usuario=cp.id_usuario)
left join empresa g on (d.id_filial = g.id_empresa)
	where cm.ch_tipo='R' 
	and d.ch_excluido is null
	and di.ch_excluido is null 
	and cm.ch_excluido is null
	
{if param_id_filial} and d.id_filial in (:id_filial) {endif}
{if param_id_item} and di.id_item in (:id_item) {endif}
{if param_emissao_ini} and d.dt_emissa between :emissao_ini and :emissao_fim {endif}

group by d.id_filial,g.ds_empresa,d.id_docfiscal,di.id_item,di.ds_item,di.vl_unitar,di.qt_item,di.vl_total,cx.ds_caixacfg,u.ds_nome
order by d.id_filial,d.dt_emissa,d.nr_docfiscal