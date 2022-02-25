
select 
    a.id_item as codigo,
    a.ds_item as item,
    b.id_grupoitem,
    b.ds_grupoitem,
    coalesce(
				(
					select 
							vl_preco
						from item_preco
						where ch_excluido is null
						and id_item =:id_item
						and id_filial =:id_filial
						and ch_predif = 'T'
						and ch_tipo = 'F'
						and id_tipopreco = (
							select id_tipopreco 
							from tipopreco 
							where ds_tipopreco = 'A VISTA' 
							limit 1)
				),
		
				(	
					select 
							vl_preco
						from item_preco
						where ch_excluido is null
						and ch_tipo = 'G'
						and id_item =:id_item
						and id_tipopreco = (
							select id_tipopreco 
							from tipopreco 
							where ds_tipopreco = 'A VISTA' 
							limit 1)
				)
			)  preco_venda
from item a
left join grupoitem b on (a.id_grupoitem = b.id_grupoitem)
where a.id_item =:id_item
and a.ch_excluido is null
and a.ch_ativo = 'T'

{if param_grupoitem} b.id_grupoitem in (:grupoitem) {endif} 
{if param_item} and a.id_item in (:id_item) {endif}

order by 2
