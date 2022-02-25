select	
		g.id_grupoitem,
		g.ds_grupoitem,
		i.id_item,
		i.ds_item,
		i.nr_codbar,
		sum(li.qt_estoque) --se remover o SUM irá repetir o item em mais de uma linha se tiver mais de um LOCALARM vinculado ao item
		from item i 
		left join grupoitem g on (i.id_grupoitem = g.id_grupoitem)
		left join localarm_item li on (i.id_item = li.id_item)
		where i.ch_excluido is null
		and i.id_item not in 
		(
			select id_item from movest_item
			where dt_movime between :data1 and :data2 --este campo dt_movime é do tipo data/hora, EX formato: 2019-01-01 23:59:59
			and ch_tipo = 'colocar S ou E' -- SOMENTE UTILIZAR ESTE FILTRO SE QUISER FILTRAR MOVIMENTOS POR CH_TIPO ENTRADA OU SAIDA
			and ch_tipo = 'S' and id_docfiscal_item is not null -- SOMENTE UTILIZAR ESTE FILTRO SE QUISER VER MOVIMENTOS DE ESTOQUE DE SAIDA COM DOCUMENTO FISCAL VINCULADO
			and ch_tipo = 'E' and id_nft_item is not null -- SOMENTE UTILIZAR ESTE FILTRO SE QUISER VER MOVIMENTOS DE ESTOQUE DE ENTRADA COM NOTA FISCAL DE TERCEIRO
			and id_invent_item is not null -- SOMENTE UTILIZAR ESTE FILTRO SE QUISER VER MOVIMENTOS COM INVENTARIO
			
		)
		group by 1,2,3,4
		order by 4
    