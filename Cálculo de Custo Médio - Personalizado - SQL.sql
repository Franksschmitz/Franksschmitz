select
    x.empresa,
    x.localarm,
    x.item,
    x.descricao,
    x.qt_estoque,
    x.preco_compra,
    (x.qt_estoque * x.preco_compra) as VL_CUSTO_EST,
    x.qt_compra,
    x.vl_compra_1,
    CAST(((x.qt_estoque * x.preco_compra) + x.vl_compra_1) / (x.qt_estoque + x.qt_compra) AS NUMERIC(26,5)) as PRECO_MEDIO,
    x.preco_venda,
    CAST(x.preco_venda - (((x.qt_estoque * x.preco_compra) + x.vl_compra_1) / (x.qt_estoque + x.qt_compra))AS NUMERIC(26,5)) as LUCRO
from (

            select 
                a.id_filial as EMPRESA,
                a.id_localarm as LOCALARM,
                a.id_item as ITEM,
                c.ds_item as DESCRICAO,
                b.qt_item as QT_ESTOQUE,
                (select vl_precom from movest_item 
                    where id_filial = a.id_filial 
                    and id_item = a.id_item
                    and dt_movime between '2000-01-01' and cast (:Data_ini as date)
                    and ch_excluido is null
                order by dt_movime desc
                limit 1 
                ) as PRECO_COMPRA,
                SUM(g.qt_rateio) as QT_COMPRA,
                SUM(d.vl_total) as VL_COMPRA_1,
                SUM(d.vl_totliq) as VL_COMPRA_2, 
                SUM(d.vl_contabil) as VL_COMPRA_3,
                (select AVG(vl_preco_nov) from reajuste_det
                    where id_item = a.id_item 
                    and id_filial = a.id_filial 
                    and ch_excluido is null
                    and cast(dh_reajuste as date) between :Data_ini and :Data_fim
                    and id_reajuste in ( select id_reajuste from reajuste where ch_situac = 'L' and ch_excluido is null )
                ) as PRECO_VENDA
            from movest_item a
            left join invent b on (a.id_item = b.id_item)
            left join item c on (b.id_item = c.id_item)
            left join nft_item d on (a.id_nft_item = d.id_nft_item)
            left join nft e on (d.id_nft = e.id_nft)
            left join localarm f on (a.id_localarm = f.id_localarm)
            left join nft_item_localarm g on (d.id_nft_item = g.id_nft_item)
                where a.ch_excluido is null
                and b.ch_excluido is null
                and d.ch_excluido is null
                and c.ch_excluido is null
                and e.ch_excluido is null
                and f.ch_excluido is null
                and g.ch_excluido is null
                and a.id_nft_item is not null
                and f.ch_combustivel = 'T'
                and c.ch_combustivel = 'T'
                and c.ch_ativo = 'T'
                and b.ch_tipo = 'M'
                and b.ch_situac = 'F'
                and e.id_filial = f.id_filial
                and a.id_filial = e.id_filial
                and a.id_filial =:Empresa
                and a.id_item in (select id_item from item where id_grupoitem =:GrupoItem or id_item in (:Item) and ch_ativo = 'T' and ch_excluido is null)
                and e.dt_saicheg between cast(:Data_ini as date) and cast(:Data_fim as date)
                and b.id_seq in ( select max(id_seq) from invent
                                    where id_filial = a.id_filial
                                    and id_item = a.id_item
                                    and ch_excluido is null
                                    and ch_tipo = 'M'
                                    and ch_situac = 'F'
                                    and dh_finaliza between '1900-01-01' and cast(:Data_ini as date))

        {if param_filial} and a.id_filial in (:Empresa) {endif}    
        {if param_item} and c.id_item in (:Item) {endif}
        {if param_emissao_ini} and e.dt_saicheg between cast(:Data_ini as date) and cast(:Data_fim as date) {endif}
            
            group by 1,2,3,4,5
            order by 4

) x