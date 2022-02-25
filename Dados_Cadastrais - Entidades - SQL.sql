


select 
e.id_entidade as "Codigo", 
e.DS_ENTIDADE as "Entidade",
CAST(e.dt_cadastro AS DATE) as "Data Cad.", 
ec.ds_contato as "Contato",
ec.ds_email as "Email", 
('(' || ec.ds_codarea || ') ' || ec.ds_fone) as "Telefone", 
('(' || ec.ds_codareacel || ') ' || ec.ds_celular) as "Celular"
from entidade e
left join entidade_endereco ee on (e.id_entidade = ee.id_entidade)
left join entidade_contato ec on (e.id_entidade = ec.id_entidade)
left join grupoentidade ge on (e.id_grupoentidade = ge.id_grupoentidade) 
where e.id_entidade not in (
select d.id_entidade from docfiscal d
where d.ch_excluido is null
and d.ch_situac = 'F'
and d.ch_gerarecpag = 'T'
and d.ch_operac = 'S'
{if param_emissao_ini} and d.dt_emissa between :emissao_ini and :emissao_fim {endif}
{if param_id_filial} and d.id_filial in (:id_filial) {endif})
and ee.ch_principal = 'T'
and e.ch_excluido is null
and e.ch_ativo = 'T'
{if param_dt_cadastro_ini} and e.dt_cadastro between :dt_cadastro_ini and :dt_cadastro_fim {endif}
{if param_id_entidade} and e.id_entidade in (:id_entidade) {endif}
{if param_id_grupoentidade} and e.id_grupoentidade in (:id_grupoentidade) {endif}
order by e.ds_entidade