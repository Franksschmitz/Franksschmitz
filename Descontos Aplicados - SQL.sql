select
   d.ds_caixacfg as "Caixa",
   c.nr_turno as "Turno",
   c.id_usuario as "Id",
   e.ds_nome as "Operador",
   a.nr_docfiscal as "Documento",
   b.id_item as "Codigo",
   f.ds_item as "Item",
   b.vl_bruto as "Valor Inicial",
   b.vl_descon as "Desconto",
   b.vl_total as "Valor Final"
from docfiscal as a
  left join docfiscal_item as b on (b.id_docfiscal = a.id_docfiscal)
  left join caixapdv as c on (c.id_caixapdv = a.id_caixapdv)
  left join caixacfg as d on (d.id_caixacfg = c.id_caixacfg)
  left join usuario as e on (e.id_usuario = a.id_usuario)
  left join item as f on (f.id_item = b.id_item)
where a.ch_excluido is null 
and a.ch_situac = 'F'
and a.ch_sitpdv = 'F'
and f.ch_combustivel = 'T'
and b.vl_descon > 0
and b.id_regrapreco is null
  {if param_empresa} and c.id_filial in (:Empresa) {endif}
  {if param_caixacfg} and d.id_caixacfg in (:Caixa) {endif}
  {if param_usuario} and c.id_usuario in (:Operador) {endif}
  {if param_emissao} and a.dt_emissa between :Emissao and :Ate {endif}
group by 1,2,3,4,5,6,7,8,9,10
order by 5 