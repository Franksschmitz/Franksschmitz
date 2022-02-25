select
	   a.id_filial,
	   a.dh_afericao as DATAHORA,
	   c.id_item as COD,
	   d.ds_item as ITEM,
	   c.nr_bico as BICO,
	   c.qt_abastecimento as QTD,
	   c.vl_abastecimento as VALOR,
	   c.id_rfid_operador,
	   i.ds_entidade as FRENTISTA,
	   a.id_responsavel,
	   e.ds_entidade as RESPONSA,
	   g.ds_caixacfg || ' ' || '- TURNO' || ' ' || f.nr_turno as CAIXA
from afericao a
left join afericao_det b on (a.id_afericao = b.id_afericao)
left join abastecimento c on (b.id_abastecimento = c.id_abastecimento)
left join item d on (c.id_item = d.id_item)
left join entidade e on (a.id_responsavel = e.id_entidade)
left join caixapdv f on (a.id_caixapdv = f.id_caixapdv)
left join caixacfg g on (f.id_caixacfg = g.id_caixacfg)
left join rfid h on (c.id_rfid_operador = h.id_rfid)
left join entidade i on (h.id_entidade = i.id_entidade)
  where a.ch_excluido is null
  and b.ch_excluido is null
  and c.ch_excluido is null
  and d.ch_combustivel = 'T'

		{if param_id_filial} and a.id_filial in (:Empresa) {endif}
		{if param_id_entidade} and e.id_entidade in (:Responsavel) {endif}
        {if param_id_item} and d.id_item in (:Combustível) {endif}
        {if param_grupoitem} and d.id_grupoitem in (:GrupoItem) {endif}
        {if param_emissao_ini} and a.dh_afericao between :Emissao_ini and :Emissao_fim {endif}
		
order by 4,2,5