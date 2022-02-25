select
    case
	   when e.ch_vinculada = 'T' then e.id_filial
	   else e.id_empresa
	end as EMPRESA,
    g.id_docfiscal as COD,
	i.ds_seriedoc as SERIE,
	g.nr_docfiscal as DOC,	
    g.dh_emissa as DATAHORA,
	case
	   when g.ch_tipo = 'CF'   then 'CF - CUPOM FISCAL'
	   when g.ch_tipo = 'NFCE' then 'NFCE - NOTA FISCAL ELETRONICA PARA CONSUMIDOR FINAL (MOD. 65)'
	   when g.ch_tipo = 'CFE'  then 'CFE - CUPOM FISCAL ELETRONICO'
	   when g.ch_tipo = 'SAT'  then 'CFE - CUPOM FISCAL ELETRONICO'
	end as TIPO,
	g.vl_total as VALOR
from docfiscal g 
left join docfiscal_eletro b on (g.id_docfiscal = b.id_docfiscal)
left join entidade d on (g.id_entidade = d.id_entidade)
left join empresa e on (g.id_filial = e.id_empresa)
left join tipolanc f on (g.id_tipolanc = f.id_tipolanc)
left join seriedoc i on (g.id_seriedoc = i.id_seriedoc)
 where b.ch_sitnfe = 'A'
 and g.ch_tipo <> 'NFE'
 and g.id_docfiscal not in ( select id_docfiscal_ref from docfiscal_docref where ch_excluido is null )

{if param_empresa} and case 
                          when e.ch_vinculada = 'T' then e.id_filial
                          else e.id_empresa end in (:Empresa) {endif}
{if param_entidade} and g.id_entidade in (:Entidade) {endif}
{if param_tipolanc} and g.id_tipolanc in (:TipoLanc) {endif}
{if param_nota} and g.nr_docfiscal in (:Nota) {endif}
{if param_serie} and i.ds_seriedoc in (:Serie) {endif}
{if param_emissao_ini} and g.dt_emissa between :Emissao and :ate {endif}

{if param_ordem_Documento} order by g.nr_docfiscal {endif}
{if param_ordem_Valor} order by g.vl_total {endif}
{if param_ordem_Emissão} order by g.dt_emissa {endif}
