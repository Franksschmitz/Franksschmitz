select
   b.dh_emissa DATAHORA_CUPOM,
   g.dt_emissao DATAHORA_ABAST,
   a.id_docfiscal_item,
   b.nr_docfiscal DOC,
   a.id_item CODIGO,
   c.ds_item DESCRICAO,
   g.nr_bico BICO,
   a.qt_item QTD,
   a.vl_unitar PRECO,
   a.vl_total VALOR,
   g.qt_encerrante_ini ENCERRANTE_INICIAL,
   g.qt_encerrante_fim ENCERRANTE_FIM
from abastecimento g
left join docfiscal_item a on (g.id_abastecimento = a.id_abastecimento)
left join docfiscal b on (a.id_docfiscal = b.id_docfiscal)
left join item c on (a.id_item = c.id_item)
left join bico d on (g.id_bico = d.id_bico)
left join caixapdv e on (b.id_caixapdv = e.id_caixapdv)
left join usuario f on (e.id_usuario_f = f.id_usuario)

 where g.qt_ence_ant = g.qt_encerrante_fim
 and b.ch_situac = 'F' and b.ch_sitpdv = 'F'
 and a.ch_excluido is null
 and g.ch_excluido is null

{if param_Empresa} and case 
                          when e.ch_vinculada = 'T' then e.id_filial
                          else g.id_empresa end in (:Empresa) {endif}
{if param_Item} and a.id_item in (:Item) {endif}
{if param_Bico} and g.id_bico in (:Bico) {endif}
{if param_emissao_ini} and b.dh_emissa between :Emissao and :Ate {endif}

 group by 3,1,2,4,5,6,7,8,9,10,11,12