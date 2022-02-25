select
  x.situacao,
  x.motorista,
  x.cpf,
  x.tipo_periodo,
  x.tipo_limite,
  x.limite,
  x.saldo,
  x.limite - x.saldo as RESTANTE,
  case 
    when (x.limite - x.saldo) > 0 then 'COM LIMITE DISPONIVEL'
    when (x.limite - x.saldo) < 0 then 'SEM LIMITE DISPONIVEL'
    when (x.limite - x.saldo) = 0 then 'SEM LIMITE DISPONIVEL'
    else 'COM LIMITE DISPONIVEL'
  end as STATUS_LIMITE
from ( 
        select 
          case
            when a.ch_ativo = 'T' then 'ATIVO'
            when a.ch_ativo = 'F' then 'INATIVO'
          end as SITUACAO,
          a.ds_mot as MOTORISTA,
          a.ds_cpf as CPF,
          case
            when b.ch_periodo = 'D' then 'DIARIO'
            when b.ch_periodo = 'S' then 'SEMANAL'
            when b.ch_periodo = 'Q' then 'QUINZENAL'
            when b.ch_periodo = 'M' then 'MENSAL'
            when b.ch_periodo = 'T' then 'TRIMESTRAL'
            when b.ch_periodo = 'A' then 'ANUAL'
          end as TIPO_PERIODO,
          case
            when b.vl_limven is not null then 'VALOR'
            else 'QUANTIDADE'
          end as TIPO_LIMITE,
          case
            when b.vl_limven is not null then b.vl_limven
            else b.qt_limven 
          end as LIMITE,
          case 
            when b.vl_limven is not null then ( select sum(di.vl_total) from docfiscal_item di
                                                left join docfiscal d on di.id_docfiscal = d.id_docfiscal
                                                    where d.ch_situac = 'F'
                                                    and d.ch_sitpdv = 'F'
                                                    and di.ch_excluido is null
                                                    and d.id_entidade_mot = a.id_entidade_mot
                                                    and d.id_docfiscal in ( select id_docfiscal from lanc 
                                                                                where id_entidade = d.id_entidade
                                                                                and id_docfiscal is not null
                                                                                and ch_situac = 'A'
                                                                                and vl_saldo > '0'
                                                                                and ch_excluido is null )) 
            else ( select sum(di.qt_item) from docfiscal_item di
                   left join docfiscal d on di.id_docfiscal = d.id_docfiscal
                      where d.ch_situac = 'F'
                      and d.ch_sitpdv = 'F'
                      and di.ch_excluido is null
                      and d.id_entidade_mot = a.id_entidade_mot
                      and d.id_docfiscal in ( select id_docfiscal from lanc 
                                                where id_entidade = d.id_entidade
                                                and id_docfiscal is not null
                                                and ch_situac = 'A'
                                                and vl_saldo > '0'
                                                and ch_excluido is null ) )          
          end as SALDO
        from entidade_mot a
        left join entidade_limven b on (a.id_entidade_mot = b.id_entidade_mot)
          where b.ch_excluido is null
          and a.ch_excluido is null
          and b.ch_tipo = 'M'
          and a.id_entidade in (:Entidade)

        {if param_Entidade} and a.id_entidade in (:Entidade) {endif}

) x