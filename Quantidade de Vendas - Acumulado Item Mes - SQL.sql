-- Quantidade de Vendas - Acumulado Item/Mês
select empresa,
       case
        when mes = '01' then 'JAN'
        when mes = '02' then 'FEV'
        when mes = '03' then 'MAR'
        when mes = '04' then 'ABR'
        when mes = '05' then 'MAI'
        when mes = '06' then 'JUN'
        when mes = '07' then 'JUL'
        when mes = '08' then 'AGO'
        when mes = '09' then 'SET'
        when mes = '10' then 'OUT'
        when mes = '11' then 'NOV'
        when mes = '12' then 'DEZ'
        else mes
       end mes,
       ano,
       item,
       descricao, 
       grupo,
       subgrupo,
       marca,
       qtd_venda
from
  (
    select 
          e.DS_EMPRESA empresa, 
          lpad((cast((extract(month from mi.DT_MOVIME)) as text)), 2, '0') mes, 
          extract(year from mi.DT_MOVIME) ano,
          i.ID_ITEM item,
          i.DS_ITEM descricao,
          case
            when (gi.ID_PAI is null) then gi.DS_GRUPOITEM
            else (select s.DS_GRUPOITEM from GRUPOITEM s where s.ID_GRUPOITEM = gi.ID_PAI) 
          end grupo,
          case
            when (gi.ID_PAI is null) then ''
            else gi.DS_GRUPOITEM
          end subgrupo,
          ma.DS_MARCA marca,
          sum(mi.QT_MOVIME) qtd_venda
    from ITEM i
    join MOVEST_ITEM mi on (i.ID_ITEM = mi.ID_ITEM)
    join DOCFISCAL_ITEM di on (mi.ID_DOCFISCAL_ITEM = di.ID_DOCFISCAL_ITEM)
    join DOCFISCAL d on (di.ID_DOCFISCAL = d.ID_DOCFISCAL)
    join EMPRESA e on (d.ID_FILIAL = e.ID_EMPRESA)
    left join GRUPOITEM gi on (i.ID_GRUPOITEM = gi.ID_GRUPOITEM)
    left join MARCA ma on (i.ID_MARCA = ma.ID_MARCA)
    where i.CH_EXCLUIDO is null and
          i.CH_ATIVO = 'T' and
          d.CH_SITUAC = 'F'   

          {if param_id_filial} and d.ID_FILIAL in (:id_filial) {endif}
          {if param_id_item} and i.ID_ITEM in (:id_item) {endif}
          {if param_grupoitem} and i.ID_GRUPOITEM in (:grupoitem) {endif}
          {if param_marca} and i.ID_MARCA in (:marca) {endif}
          {if param_emissao_ini} and mi.DT_MOVIME between :emissao_ini and :emissao_fim {endif}

    group by 1,2,3,4,5,6,7,8
    order by 3,2,6,5
  ) x