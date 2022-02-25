select 
    *
from (
    select
        x.COD,
        x.ENT,
        x.QT_VENDA,
        x.VALOR,
        cast((x.VALOR / x.QT_VENDA) as numeric(36,3)) as TICKET_MEDIO,
        cast((100 + ((x.UTI / x.LIM)  - 1 ) * 100) as numeric(26,2)) PERCENTUAL,
        case
            when x.ch_especie = 'T' then 'SIM'
            else 'NAO'
        end as BLOQ,
        x.ID_ESPECIE,
        x.ESP,
        case
            when x.ch_sitcre = 'A' then 'APROV.'
            when x.ch_sitcre = 'B' then 'BLOQ.'
            when x.ch_sitcre = 'D' then 'DESBLOQ.'
        end as SITUAC,
        x.LIM,
        x.UTI,
        case
            when x.UTI = null         then x.LIM
            when x.UTI is null        then x.LIM
            when x.LIM - x.UTI = null then x.LIM
            when x.LIM - x.UTI = 0    then x.LIM
            else x.LIM - x.UTI
        end as SALDO,
        case
            when x.ch_sitcre = 'B'   then 'Indisponivel'
            when (x.LIM - x.UTI) = 0 then 'Indisponivel'
            when (x.LIM - x.UTI) > 0 then 'Disponivel'
            when (x.LIM - x.UTI) < 0 then 'Excedido'
            else 'Limite Disponivel'
        end as STATUS	   
        from (
                        select  
                            b.id_entidade as COD,
                            a.ds_entidade as ENT,
                            b.ch_tipo,
                            case 
                                when cast(b.id_filial as varchar(10)) = '' then 'GERAL'
                                when cast(b.id_filial as varchar(10)) = 'null' then 'GERAL'
                                when cast(b.id_filial as varchar(10)) = '0' then 'GERAL'
                                else e.ds_empresa
                            end as EMP,  
                            (select cast(sum(db.vl_valor) as numeric(36,3)) from docfiscal df
                            left join docfiscal_baixa db on (df.id_docfiscal = db.id_docfiscal)
                                where df.id_entidade = b.id_entidade
                                and db.id_especie = b.id_especie
                                and db.ch_excluido is null
                                and df.ch_excluido is null
                                and db.ch_operac = 'B'
                                and df.ch_situac = 'F'
                                and df.dt_emissa > cast(current_date - cast(30 as integer)as date)) as VALOR,
                            (select count(df.nr_docfiscal) from docfiscal df
                                where df.id_entidade = b.id_entidade
                                and df.id_especie = b.id_especie
                                and df.ch_situac = 'F'
                                and df.dt_emissa > cast(current_date - cast(30 as integer)as date)) as QT_VENDA,
                            b.ch_especie,
                            b.id_especie,
                            case 
                                when b.id_especie is not null then d.ds_especie
                                else 'TODAS'
                            end as ESP,
                            b.ch_sitcre,
                            b.vl_limcre as LIM,
                            (select cast(sum(l.vl_saldo) as numeric(36,3)) from lanc l
                            left join planoconta pc on (l.id_planoconta = pc.id_planoconta)
                                where l.ch_situac = 'A'
                                and l.vl_saldo > 0
                                and l.id_entidade = b.id_entidade
                                and l.id_especie = b.id_especie
                                and l.ch_excluido is null
                                and l.ch_ativo = 'T'
                                and pc.ch_ativo = 'T'
                                and pc.ch_excluido is null
                                and pc.ch_cont_fin <> 'P') as UTI
                        from entidade_cred b
                        left join entidade a on (b.id_entidade = a.id_entidade)
                        left join especie d on (b.id_especie = d.id_especie)
                        left join grupoentidade c on (a.id_grupoentidade = c.id_grupoentidade)
                        left join empresa e on (b.id_filial = e.id_empresa)
                            where b.id_entidade = a.id_entidade
                            and b.ch_excluido is null
                            and a.ch_ativo = 'T'
                            and a.ch_excluido is null
                            and d.ch_ativo = 'T'

                        {if param_Grupo} and c.id_grupoentidade in (:Grupo) {endif}
                        {if param_Entidade} and b.id_entidade in (:Entidade) {endif}
                        {if param_Especie} and b.id_especie in (:Especie) {endif}

                        group by 1,2,3,4,5,6,7,8,9,10,11,12

            ) x

    group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14

) l

{if param_Percentual} where l.percentual between :Percentual and :Ate {endif}
{if param_ordem_Percentual_Utilizado} order by l.percentual desc {endif}
{if param_ordem_Quantidade_Vendas} order by l.qt_venda desc {endif}
{if param_ordem_Entidade} order by l.ent asc {endif}