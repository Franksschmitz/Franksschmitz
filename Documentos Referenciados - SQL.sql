select
    case
	   when e.ch_vinculada = 'T' then e.id_filial
	   else e.id_empresa
	end as EMPRESA,
    a.id_docfiscal as COD,
	i.ds_seriedoc as SERIE,
	a.nr_docfiscal as NF,
    c.id_docfiscal_ref as DOCREF,	
    g.dh_emissa as DATAHORA,
	case
	   when g.ch_tipo = 'CF'   then 'CF - CUPOM FISCAL'
	   when g.ch_tipo = 'NFCE' then 'NFCE - NOTA FISCAL ELETRONICA PARA CONSUMIDOR FINAL (MOD. 65)'
	   when g.ch_tipo = 'CFE'  then 'CFE - CUPOM FISCAL ELETRONICO'
	   when g.ch_tipo = 'SAT'  then 'CFE - CUPOM FISCAL ELETRONICO'
	end as TIPO,
	c.nr_nota_ref as DOC,
	g.vl_total as VALOR
from docfiscal a 
left join docfiscal_eletro b on (a.id_docfiscal = b.id_docfiscal)
left join docfiscal_docref c on (a.id_docfiscal = c.id_docfiscal)
left join docfiscal g on (c.id_docfiscal_ref = g.id_docfiscal)
left join entidade d on (a.id_entidade = d.id_entidade)
left join empresa e on (a.id_filial = e.id_empresa)
left join tipolanc f on (a.id_tipolanc = f.id_tipolanc)
left join seriedoc i on (a.id_seriedoc = i.id_seriedoc)
 where b.ch_sitnfe = 'A'
 and a.ch_tipo = 'NFE'
 and a.ch_excluido is null
 and b.ch_excluido is null
 and c.ch_excluido is null

{if param_empresa} and case 
                          when e.ch_vinculada = 'T' then e.id_filial
                          else e.id_empresa end in (:Empresa) {endif}
{if param_nota} and a.nr_docfiscal in (:Nota) {endif}
{if param_serie} and i.ds_seriedoc in (:Serie) {endif}
{if param_tipolanc} and a.id_tipolanc in (:TipoLanc) {endif}
{if param_entidade} and a.id_entidade in (:Entidade) {endif}
{if param_emissao_ini} and a.dt_emissa between :Emissao and :ate {endif}

order by 4 desc