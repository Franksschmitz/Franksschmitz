select
   a.id_bomba as "Id",
   case
      when a.nr_bomba > 0 then 'BOMBA' || ' ' || a.nr_bomba
      when a.nr_bomba = 0 then a.nr_serie
   end as "Bomba",
   a.nr_bomba as "N Bomba",
   a.ds_modelo as "Modelo",
   a.nr_serie as "N Serie",
   c.id_concentrador as "Id Conc",
   c.ds_concentrador as "Descricao",
   b.nr_lacre as "N Lacre",
   b.dt_vigencia as "Vigencia",
   case
      when dt_desativacao is null      then 'BOMBA ATIVA'
      when dt_desativacao is not null then 'BOMBA INATIVA'
end as "Situacao"
from bomba a
left join bomba_lacre b on (a.id_bomba = b.id_bomba)
left join concentrador c on (a.id_concentrador = c.id_concentrador)
left join empresa d on (a.id_filial = d.id_filial)
left join entidade e on (a.id_fabricante = e.id_entidade)
where a.ch_ativo = 'T'
and a.ch_excluido is null
and b.ch_ativo = 'T'
and b.ch_excluido is null
and c.ch_ativo = 'T'
and c.ch_excluido is null

    {if param_id_empresa} and d.id_filial in (:Empresa){endif}
    {if param_id_fabricante} and e.id_entidade in (:Fabricante) {endif}
    {if param_id_concentrador} and c.id_concentrador in (:Concentrador){endif}
    {if param_id_bomba} and a.id_bomba in (:Bomba){endif}
    {if param_nr_bomba} and a.nr_bomba in (:NBomba){endif}

order by a.nr_bomba