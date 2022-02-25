select
   a.dh_lanc as DATAHORA,
   d.ds_empresa as EMPRESA,
   b.ds_entidade as NOME,
   b.ds_cpfcnpj as CPFCNPJ,
   a.nr_docume as VALE,
   a.vl_valor as VALOR,
   a.ds_historico as HISTORICO
from lanc as a
left join entidade as b on (a.id_entidade = b.id_entidade)
left join empresa as d on (a.id_empresa = d.id_empresa)
left join tipolanc as e on (a.id_tipolanc = e.id_tipolanc)
where a.id_lanc in (:id)