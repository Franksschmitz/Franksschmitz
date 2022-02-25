select 
    a.id_item as codigo,
    a.ds_item as item,
    coalesce(
				(
					select 
							vl_preco
						from item_preco
						where ch_excluido is null
						and id_item = a.id_item
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
						and id_item = a.id_item
						and id_tipopreco = (
							select id_tipopreco 
							from tipopreco 
							where ds_tipopreco = 'A VISTA' 
							limit 1)
				)
			)  preco_venda
from item a
left join grupoitem b on (a.id_grupoitem = b.id_grupoitem)
left join item_filial d on (a.id_item = d.id_item)
left join empresa c on (d.id_filial = c.id_empresa)
where d.id_filial =:id_filial
and a.ch_ativo = 'T'
and a.ch_revenda = 'T'
and a.ch_excluido is null
and d.ch_excluido is null

{if param_Empresa} and c.id_empresa in (:id_filial) {endif}  
{if param_grupoitem} and b.id_grupoitem in (:grupoitem) {endif} 
{if param_item} and a.id_item in (:id_item) {endif}
order by 2