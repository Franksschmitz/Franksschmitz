select 
   a.id_item ITEM,
   a.ds_item NOME,
   d.id_grupoitem COD,
   d.ds_grupoitem DESCRICAO,
   'IMENDES' INTEGRACAO,
   b.ds_codigo CODIGO
from item a 
left join item_integracao b on (a.id_item = b.id_item)
left join integracao c on (b.id_integracao = c.id_integracao)
left join grupoitem d on (a.id_grupoitem = d.id_grupoitem)
	where c.ds_identificador = 'IMENDES'
	and b.ch_excluido is null
	and c.ch_excluido is null
	and a.ch_excluido is null
	and a.ch_ativo = 'T'

    {if param_grupoitem} and d.id_grupoitem in (:GrupoItem){endif}
    {if param_item} and a.id_item in (:Item){endif}
    {if param_codigo} and b.ds_codigo in (:Codigo){endif}
order by 4,2