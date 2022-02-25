select
	  x.et,
	  x.gc,
	  cast ((100 + ((x.et / x.gc)  - 1 ) * 100) as numeric(26)) PERCENTUAL
from (
				select
				   ( select 
						coalesce(
										(
											select 
													cast((a.vl_preco) as numeric (24,3))
												from item_preco a
												left join item b on (a.id_item = b.id_item)
												where a.ch_excluido is null
												and b.id_tabanp in ('300-1','301-1','302-1')
												and a.id_filial in (select id_filial from empresa$lo where ch_local = 'T')
												and a.ch_predif = 'T'
												and a.ch_tipo = 'F'
												and b.ch_ativo = 'T'
												and b.ch_excluido is null
												and a.id_tipopreco = (
													select id_tipopreco 
													from tipopreco 
													where ds_tipopreco = 'A VISTA' 
													limit 1)
										),
								
										(	
											select 
													cast((a.vl_preco) as numeric (24,3))
												from item_preco a
												left join item b on (a.id_item = b.id_item)
												where a.ch_excluido is null
												and a.ch_tipo = 'G'
												and b.id_tabanp in ('300-1','301-1','302-1')
												and b.ch_ativo = 'T'
												and b.ch_excluido is null
												and a.id_tipopreco = (
													select id_tipopreco 
													from tipopreco 
													where ds_tipopreco = 'A VISTA' 
													limit 1)
										)
						)) ET,
					
					   ( select 
						coalesce(
										(
											select 
													cast((a.vl_preco) as numeric (24,3))
												from item_preco a
												left join item b on (a.id_item = b.id_item)
												where a.ch_excluido is null
												and b.id_tabanp in ('345-1','686-1','687-1')
												and a.id_filial in (select id_filial from empresa$lo where ch_local = 'T')
												and a.ch_predif = 'T'
												and a.ch_tipo = 'F'
												and b.ch_ativo = 'T'
												and b.ch_excluido is null
												and a.id_tipopreco = (
													select id_tipopreco 
													from tipopreco 
													where ds_tipopreco = 'A VISTA' 
													limit 1)
										),
								
										(	
											select 
													cast((a.vl_preco) as numeric (24,3))
												from item_preco a
												left join item b on (a.id_item = b.id_item)
												where a.ch_excluido is null
												and a.ch_tipo = 'G'
												and b.id_tabanp in ('345-1','686-1','687-1')
												and b.ch_ativo = 'T'
												and b.ch_excluido is null
												and a.id_tipopreco = (
													select id_tipopreco 
													from tipopreco 
													where ds_tipopreco = 'A VISTA' 
													limit 1)
										)
						)) GC
					
				from item 
				where id_tabanp in ('300-1','301-1','302-1','345-1','686-1','687-1')
				
				
			{if param_empresa} and id_empresa in (:Empresa) {endif}
			limit 1
) x 

 
