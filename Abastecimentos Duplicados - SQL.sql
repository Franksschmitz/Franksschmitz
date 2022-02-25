select
   g.dt_emissao as DATAHORA,
   g.id_empresa as Empresa,
   case
      when g.ch_situac = 'P' then 'PENDENTE'
      when g.ch_situac = 'B' then 'BAIXADO'
   end as SITUACAO,
   case
      when g.ch_ativo = 'T' then 'SIM'
      when g.ch_ativo = 'F' then 'NÃO'
   end as ATIVO,
   g.id_abastecimento as COD_ABAST,
   g.id_item as COD_ITEM,
   c.ds_item as DESCRICAO,
   g.nr_bico as BICO,
   g.qt_abastecimento as QTD,
   g.vl_preco as PRECO,
   g.vl_abastecimento as VALOR,
   g.qt_encerrante_ini as ENCERRANTE_INICIAL,
   g.qt_encerrante_fim as ENCERRANTE_FIM
from abastecimento g
left join item c on (g.id_item = c.id_item)
left join bico d on (g.id_bico = d.id_bico)
left join abastecimento a on (g.id_item = a.id_item)
left join empresa e on (g.id_empresa = e.id_empresa)
 where g.qt_encerrante_ini = a.qt_encerrante_ini
 and g.id_abastecimento <> a.id_abastecimento
 and g.ch_excluido is null
 

{if param_Empresa} and case 
                          when e.ch_vinculada = 'T' then e.id_filial
                          else g.id_empresa end in (:Empresa) {endif}
{if param_Item} and g.id_item in (:Item) {endif}
{if param_Bico} and g.id_bico in (:Bico) {endif}
{if param_Emissao_ini} and g.dt_emissao between :Emissao_ini and :Emissao_fim {endif}

 group by 1,2,3,4,5,6,7,8,9,10,11,12,13
 order by 12,1