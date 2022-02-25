select

		   s.id_entidade as "Entidade",
		   s.ds_entidade as "Nome",
		   s.ds_placa as "Placa",
		   s.dh_emissa as "DataHora",
	       s.tipo as "Tipo",
		   s.nr_docfiscal as "Documento",
		   s.ds_item as "Item",
		   s.qt_item as "Litros",
		   s.vl_preco as "Preco Cadastro",
		   s.vl_unitar as "Preco Venda",
		   sum(s.vl_preco) * s.qt_item as "Valor Bruto",
		   sum(s.vl_unitar) * s.qt_item as "Valor Pago",
		   sum(s.vl_preco - s.vl_unitar) * s.qt_item as "Descontos"
from 
	(
		select
		   a.id_entidade,
		   e.ds_entidade,
		   a.ds_placa,
		   a.dh_emissa,
		   case
			  when a.ch_tipo = 'NFCE' then 'NFC-E'
			  when a.ch_tipo = 'CF'   then 'CF'
			  when a.ch_tipo = 'CFE'  then 'CF-E'
			  when a.ch_tipo = 'NFE'  then 'NF-E'
		   end as tipo,
		   a.nr_docfiscal,
		   f.ds_item,
		   b.qt_item,
		coalesce(
						(
							select 
									vl_preco
								from item_preco
								where ch_excluido is null
								and id_item = b.id_item
								and id_filial = a.id_empresa
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
								and id_item = b.id_item
								and ch_tipo = 'G'
								and id_tipopreco = (
									select id_tipopreco 
									from tipopreco 
									where ds_tipopreco = 'A VISTA' 
									limit 1)
						)
		 ) as vl_preco,
		   b.vl_unitar,   
		   b.vl_total
		from docfiscal as a
		  left join docfiscal_item as b on (b.id_docfiscal = a.id_docfiscal)
		  left join item as f on (f.id_item = b.id_item)
		  left join entidade as e on (e.id_entidade = a.id_entidade)
		  left join empresa as h on (h.id_empresa = a.id_empresa)
		where a.ch_excluido is null
		and b.ch_excluido is null
		and a.ds_placa is not null
		and a.ch_situac = 'F'
		and a.ch_sitpdv = 'F'
		and f.ch_combustivel = 'T'
		--and a.id_empresa = ( select id_empresa$lo from empresa$lo where ch_local = 'T' )
        --and b.vl_per_descon = '0'
		and b.id_regrapreco in 
		( 
			select id_regrapreco 
			from regrapreco_apl 
			where ch_forma_apl = 'V' 
			and ch_excluido is null  
				   )
		  {if param_empresa} and h.id_empresa in (:Empresa) {endif}
		  {if param_item} and f.id_item in (:Item) {endif}
		  {if param_entidade} and e.id_entidade in (:Entidade) {endif}
		  {if param_emissao} and a.dt_emissa between :Emissao and :Ate {endif}
		group by 1,2,3,4,5,6,7,8,9,10,11
		order by 4,3
) s  

group by 1,2,3,4,5,6,7,8,9,10