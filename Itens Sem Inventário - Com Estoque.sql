select	
    l.id_filial,	
    g.id_grupoitem,
    g.ds_grupoitem,
    i.id_item,
    i.ds_item,
    i.nr_codbar,
    sum(li.qt_estoque) Estoque
from item i 
left join grupoitem g on (i.id_grupoitem = g.id_grupoitem)
left join localarm_item li on (i.id_item = li.id_item)
left join localarm l on (li.id_localarm = l.id_localarm)
left join movest_item mi on (i.id_item = mi.id_item)
    where i.ch_excluido is null
    and i.ch_ativo = 'T'
    and li.qt_estoque > 0
    and i.ch_combustivel = 'F'
    and mi.id_filial = l.id_filial
    and i.id_item not in (

                            select id_item from movest_item
                            where dt_movime between :emissao_ini and :emissao_fim
                            and id_invent_item is not null    )
    and mi.id_seq in (
                            select max(id_seq) from movest_item
                            where id_item = i.id_item 
                            and ch_excluido is null  )
    

{if param_Empresa} and l.id_filial in (:Empresa) {endif}
{if param_GrupoItem} and g.id_grupoitem in (:GrupoItem) {endif}
{if param_Item} and i.id_item in (:Item) {endif}
{if param_emissao_ini} and mi.dt_movime between :emissao_ini and :emissao_fim {endif}

group by 1,2,3,4,5,6
order by 5
    