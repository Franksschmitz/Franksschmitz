select
	a.nr_sequen as NR_SEQUENCIA,
	a.dh_emissa as EMISSAO_REM,
	d.id_entidade as CODIGO,
	d.ds_entidade as ENTIDADE,
	c.dt_doc as EMISSAO,
	c.nr_docume as NR_DOC,
	b.nr_bancar as NOSSO_NUMERO,
	c.dt_vencim as VENCIMENTO,
	c.vl_valor as VALOR,
	c.vl_pago as PAGO,
	c.vl_saldo as SALDO,
	case
		when c.vl_saldo <> '0' and c.vl_saldo <> c.vl_valor then 'PARCIALMENTE LIQUIDADO'
		when ch_situac = 'A'                                then 'ABERTO'
		when ch_situac = 'L' 	                            then 'LIQUIDADO'
	end as SITUACAO
from remessaban a
left join remessaban_item b on (a.id_remessaban = b.id_remessaban)
left join lanc c on (b.id_lanc = c.id_lanc)
left join entidade d on (c.id_entidade = d.id_entidade)
	where a.ch_excluido is null
	and b.ch_excluido is null
	and c.ch_excluido is null
	
{if param_empresa} and a.id_empresa in (:Empresa) {endif}
{if param_entidade} and d.id_entidade in (:Entidade) {endif}
{if param_sequencia} and a.nr_sequen in (:Sequencia) {endif}
{if param_emissao_ini} and a.dh_emissa between :Emissao_ini and :Emissao_fim {endif}

order by 1