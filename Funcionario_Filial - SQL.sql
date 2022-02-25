SELECT 
  ef.id_entidade as "Código",
  e.ds_entidade as "Entidade",
  ef.id_filial as "Cód.",
  em.ds_empresa as "Empresa",
  ge.ds_grupoentidade as "Grupo"
FROM entidade e
join entidade_filial ef on (ef.id_entidade = e.id_entidade)
join grupoentidade ge on (ge.id_grupoentidade = e.id_grupoentidade)
inner join empresa em on (em.id_empresa = ef.id_filial)
   where e.ch_funcionario = 'T'
   and ef.ch_excluido is null
   and e.ch_ativo = 'T'
   
   {if param_Empresa} and em.id_empresa in (:Empresa) {endif}
   
   group by 3,4,5,2,1