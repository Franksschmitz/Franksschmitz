select
   x.id,
   x.filial,
   x.empresa,
   x.deposito,
   x.grupoitem,
   x.descricao,
   x.emissao,
   x.finalizado,
   x.codigo,
   x.item,
   x.custo_medio,
   x.estoque,
   x.coletado,
   x.digitado,
   x.dt_leitura,
   x.perda,
   x.sobra,
   x.sobra - x.perda as DIF,
   cast((x.perda * x.custo_medio) as numeric(12,3)) as vl_perda,
   cast((x.sobra * x.custo_medio) as numeric(12,3)) as vl_sobra,
   x.situacao
from (
    			 select
					  i.id_invent as ID,
					  i.id_filial as FILIAL,
					  e.ds_empresa as EMPRESA, 
					  l.ds_localarm as DEPOSITO,
                      gi.id_grupoitem as GRUPOITEM,
                      gi.ds_grupoitem as DESCRICAO, 
					  i.dt_emissa as EMISSAO, 
					  i.dh_finaliza as FINALIZADO,
					  ii.id_item as CODIGO, 
					  it.ds_item as ITEM, 
					  ic.vl_precusmed as CUSTO_MEDIO,
					  ii.qt_estoque as ESTOQUE, 
					  ii.QT_Leitura as COLETADO, 
					  ii.qt_item as DIGITADO,
					  ii.dh_leitura as DT_LEITURA,
					  case
						 when ii.qt_item - ii.qt_estoque < 0 then ii.qt_item - ii.qt_estoque
						 else 0
					  end as PERDA,
					  case
						 when ii.qt_item - ii.qt_estoque > 0 then ii.qt_item - ii.qt_estoque
						 else 0
					  end as SOBRA,
					  i.ch_situac as SITUACAO
				from invent i
				left join invent_item ii on (i.id_invent=ii.id_invent)
				left join item it on (ii.id_item=it.id_item)
				left join grupoitem gi on (it.id_grupoitem=gi.id_grupoitem)
				left join localarm l on (i.id_localarm=l.id_localarm)
				left join empresa e on (i.id_filial=e.id_empresa)
				left join item_custo ic on (ii.id_item = ic.id_item)
					where i.ch_tipo = 'I' 
					and i.ch_excluido is null 
					and ii.ch_excluido is null
					and ic.ch_excluido is null 
					and i.id_filial = ic.id_filial
					and i.ch_situac <> 'C'

                  group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,18
			
	) x
 
 where x.digitado > 0

{if param_id_filial}    and x.filial    in (:Empresa)                       {endif}
{if param_id_item}      and x.codigo    in (:Item)                          {endif}
{if param_id_grupoitem} and x.grupoitem in (:GrupoItem)                     {endif}
{if param_emissao_ini}  and x.emissao between :emissao_ini and :emissao_fim {endif}

{if param_ordem_Emissão}   order by x.emissao     {endif}
{if param_ordem_Item}      order by x.item        {endif}
{if param_ordem_Perda}     order by x.perda asc   {endif}
{if param_ordem_Sobra}     order by x.sobra desc  {endif}
{if param_ordem_Diferença} order by dif     desc  {endif}
