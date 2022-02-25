select
    x.empresa,
	x.cod,
	x.fornecedor,
	x.chegada,
	x.codigo,
	x.item,
	x.cfop,
	x.cst,
	x.nfe,
	x.quantidade,
	x.total,
	x.custo,
	x.venda,
	cast((((x.venda/x.custo) * 100) - 100) as numeric(15,3)) as MARGEM
from (
				select
				   a.id_filial as EMPRESA,
				   a.id_entidade as COD,
				   d.ds_entidade as FORNECEDOR,
				   a.dt_saicheg as CHEGADA,
				   b.id_item as CODIGO,
				   c.ds_item as ITEM,
				   f.nr_natoper as CFOP,
				   g.nr_cst as CST,
				   a.nr_notafi as NFE,
				   b.qt_movest as QUANTIDADE,
				   b.vl_total as TOTAL,
				   case
                        when mi.vl_precus = '0' then (coalesce(
                                                                (
                                                                    select 
                                                                            vl_preco
                                                                        from item_preco
                                                                        where ch_excluido is null
                                                                        and id_item = b.id_item
                                                                        and id_filial = a.id_filial
                                                                        and ch_predif = 'T'
                                                                        and ch_tipo = 'F'
                                                                        and id_tipopreco = '1-1'
                                                                ),
                                                        
                                                                (	
                                                                    select 
                                                                            vl_preco
                                                                        from item_preco
                                                                        where ch_excluido is null
                                                                        and ch_tipo = 'G'
                                                                        and id_item = b.id_item
                                                                        and id_tipopreco = '1-1'
                                                                )
                                                        ))
                        else mi.vl_precus
                   end as CUSTO,
				   coalesce(
									(
										select 
												vl_preco
											from item_preco
											where ch_excluido is null
											and id_item = b.id_item
											and id_filial = a.id_filial
											and ch_predif = 'T'
											and ch_tipo = 'F'
											and id_tipopreco = '1-1'
									),
							
									(	
										select 
												vl_preco
											from item_preco
											where ch_excluido is null
											and ch_tipo = 'G'
											and id_item = b.id_item
											and id_tipopreco = '1-1'
                                    )
							) VENDA
				from nft a
				left join nft_item b on (a.id_nft = b.id_nft)
				left join item c on (b.id_item = c.id_item)
				left join entidade d on (a.id_entidade = d.id_entidade)
				left join nft_item_imposto e on (b.id_nft_item = e.id_nft_item)
				left join natoper f on (b.id_natoper = f.id_natoper)
				left join cst g on (e.id_cst = g.id_cst)
				left join movest_item mi on (b.id_nft_item = mi.id_nft_item)
					where a.ch_excluido is null
					and b.ch_excluido is null
					and e.ch_excluido is null
					and mi.ch_excluido is null
					and b.id_nft_item = mi.id_nft_item
					and e.id_imposto = '1-1'
                    and b.id_item in ( select id_item from item where ch_revenda = 'T' or ch_combustivel = 'T')
					and e.id_cst in ( select id_cst from cst where id_imposto = '1-1' and ch_excluido is null and ch_ativo = 'T' )
				
				{if param_Empresa} and a.id_filial in (:Empresa) {endif}
				{if param_Fornecedor} and a.id_entidade in (:Fornecedor) {endif}
                {if param_GrupoItem} and c.id_grupoitem in (:GrupoItem) {endif}
				{if param_Item} and c.id_item in (:Item) {endif}
				{if param_Emissao_ini} and a.dt_saicheg  between :Emissao_ini and :Emissao_fim {endif}
				
				
	) x
	
	order by 3,4,6

