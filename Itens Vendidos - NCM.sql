select
   a.id_item as CODIGO,
   c.ds_item as ITEM,
   c.id_grupoitem,
   g.ds_grupoitem as GRUPO,
   a.id_classfiscal,
   d.nr_ncm as NCM,
   d.ds_classfiscal as DESCRICAO 
from docfiscal_item a 
left join docfiscal b on a.id_docfiscal = b.id_docfiscal
left join item c on a.id_item = c.id_item
left join classfiscal d on a.id_classfiscal = d.id_classfiscal
left join empresa e on b.id_filial = e.id_empresa
left join grupoitem g on c.id_grupoitem = g.id_grupoitem
	where b.ch_situac = 'F' 
	and b.ch_tipo <> 'NFE'
	and b.ch_excluido is null
	and c.ch_excluido is null
	and c.ch_ativo = 'T'
 
{if param_Empresa} and case
	                  when e.ch_vinculada = 'T'  then e.id_filial in (:Empresa)
		              when e.ch_vinculada <> 'T' then a.id_filial in (:Empresa) 
		           end {endif}
{if param_item} and c.id_item in (:Item) {endif} 
{if param_grupoitem} and g.id_grupoitem in (:GrupoItem) {endif}                       
{if param_Emissao_ini} and b.dt_emissa between :emissao_ini and :emissao_fim {endif}

group by 1,2,3,4,5,6,7
order by 6,2