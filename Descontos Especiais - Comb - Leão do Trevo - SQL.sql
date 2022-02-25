select
   b.id_docfiscal_item,
   c.nr_turno as "Turno",
   d.ds_caixacfg as "Caixa",
   a.nr_docfiscal as "Documento",
   b.id_item as "Codigo",
   f.ds_item as "Item",
   b.vl_bruto as "Valor Inicial",
   b.vl_descon as "Desconto",
   b.vl_total as "Valor Final"
from docfiscal as a
  left join docfiscal_item as b on (a.id_docfiscal = b.id_docfiscal)
  left join caixapdv as c on (a.id_caixapdv = c.id_caixapdv)
  left join caixacfg as d on (c.id_caixacfg = d.id_caixacfg)
  left join usuario as e on (a.id_usuario = e.id_usuario)
  left join item as f on (b.id_item = f.id_item)
where b.id_regrapreco = '10-5'
and b.vl_descon_item > 0
and f.ch_combustivel = 'T'
and a.ch_situac = 'F'
and a.ch_sitpdv = 'F'
and a.ch_excluido is null
and b.ch_excluido is null 

  {if param_empresa} and a.id_filial in (:Empresa) {endif}
  {if param_caixa} and c.dt_abertura between :Caixa and :Ate {endif}
  {if param_turno} and c.nr_turno in (:Turno) {endif}
group by 1,2,3,4,5,6,7,8,9
order by 4