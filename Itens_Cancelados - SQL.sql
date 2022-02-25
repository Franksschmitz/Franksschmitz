select
    i.id_item as "Código", 
    i.ds_item as "Item",
    d.dt_emissa as "Data", 
    d.hr_emissa as "Hora",
    d.nr_docfiscal as "COO",
    u.ds_nome as "Usuario",
    cp.nr_turno as "Turno"
from docfiscal d
left join docfiscal_item as di on (di.id_docfiscal = d.id_docfiscal)
left join item as i on (i.id_item = di.id_item)
left join usuario as u on (u.id_usuario = d.id_usuario)
left join caixapdv as cp on (cp.id_caixapdv = d.id_caixapdv)
left join caixacfg as e on (e.id_caixacfg = cp.id_caixacfg)
left join lanc as c on (c.id_entidade = u.id_entidade)
left join empresa as f on (f.id_empresa = cp.id_empresa)
  where di.ch_excluido = 'T'
  and di.ch_cancelado = 'T'
  and d.ch_situac = 'F'
{if param_Empresa} and f.id_empresa in (:Empresa){endif}
{if param_Caixa} and e.id_caixacfg in (:Caixa){endif}
{if param_Turno} and cp.nr_turno in (:Turno){endif}
{if param_Emissao} and d.dt_emissa between :Emissao and :Ate {endif}