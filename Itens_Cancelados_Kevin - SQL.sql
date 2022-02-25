select
	
	d.nr_docfiscal as "Documento",
	d.dh_emissa,
	case
		when di.ch_excluido = 'T'
		then 'SIM'
		else 'NAO'	
	end cancelado,	
	di.id_item,
	i.ds_item,
	di.qt_item,
	di.vl_unitar,
	di.vl_contabil,
	u.ds_nome,
	cx.nr_turno,
	cx.id_caixapdv,
	case
		when d.ch_tipo = 'NFCE' then 'NFC-E'
		when d.ch_tipo = 'CF' then 'CUPOM FISCAL'
		when d.ch_tipo = 'CFE' then 'CF-E'
		when d.ch_tipo = 'NFE' then 'NF-E'
	end tipo
	
	from docfiscal_item di
	join docfiscal d on di.id_docfiscal = d.id_docfiscal
	join item i on di.id_item = i.id_item
	join caixapdv cx on d.id_caixapdv = cx.id_caixapdv
	join usuario u on cx.id_usuario = u.id_usuario
	
	where di.id_docfiscal in (
		
		select sdi.id_docfiscal 
		from docfiscal_item sdi
		join docfiscal sd on sdi.id_docfiscal = sd.id_docfiscal
		join item si on sdi.id_item = si.id_item
		join caixapdv scx on sd.id_caixapdv = scx.id_caixapdv
		join usuario su on scx.id_usuario = su.id_usuario
		where sdi.ch_excluido = 'T' 
		and sd.ch_situac = 'F'
		and sd.ch_tipo in ('NFCE','CF','CFE','NFE')
                and sd.dh_emissa between :dt_ini and :dt_fim
	
		{if param_id_empresa} and sd.id_filial in (:id_empresa) {endif}
		{if param_id_grupoitem} and si.id_grupoitem in (:id_grupoitem) {endif}
		{if param_id_item} and sdi.id_item in (:id_item) {endif}
		{if param_id_caixacfg} and scx.id_caixacfg in (:id_caixacfg) {endif}
        {if param_nr_turno} and scx.nr_turno in (:nr_turno) {endif}
		{if param_id_usuario} and su.id_usuario in (:id_usuario) {endif}
		{if param_dh_emissao} and sd.dh_emissa between :dt_ini and :dt_fim {endif}
		
	)
order by 1,2,3