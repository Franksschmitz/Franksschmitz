select
  case
    when d.ch_vinculada = 'T'   then d.id_filial
    when d.ch_vinculada is null then d.id_empresa
    when d.ch_vinculada = 'F'   then d.id_empresa
  end as "Empresa", 
  a.id_item as "Cod Item",
  a.ds_item as "Descricao",
  b.id_entidade as "Entidade",
  c.ds_entidade as "Nome",
  b.nr_entidade as "Cod Fornecedor",
  b.ds_entidade as "Desc Fornecedor",
  b.vl_ultcompra as "Preco Compra"
from item a
left join item_entidade b on (a.id_item = b.id_item)
left join entidade c on (b.id_entidade = c.id_entidade)
left join empresa d on (b.id_empresa = d.id_empresa)
left join grupoitem e on (a.id_grupoitem = e.id_grupoitem)
    where b.vl_ultcompra > 0
    and b.ch_excluido is null
    and b.id_seq in (
                        select 
                            id_seq
                        from item_entidade
                        where id_item = b.id_item
                        limit 20
                                  )
             
{if param_empresa} and d.id_empresa in (:Empresa) {endif}
{if param_entidade} and c.id_entidade in (:Entidade) {endif}
{if param_GrupoItem} and e.id_grupoitem in (:GrupoItem) {endif}
{if param_item} and a.id_item in (:Item) {endif} 
                                      
group by 1,2,3,4,5,6,7,8
order by 3,6 asc