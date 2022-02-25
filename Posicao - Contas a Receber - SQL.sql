select
   x.codigo,
   x.nconta,
   x.conta,
   x.quantidade,
   x.saldo
from (



        select
           a.id_planoconta as "codigo",
           b.nr_planoconta as "nconta",
           b.ds_planoconta as "conta",
           case 
             when b.nr_planoconta like '01.03.001.0%' then count(d.id_concirecpag)
             when b.nr_planoconta not like '01.03.001.0%' then count(a.id_lanc)
           end as "quantidade",
           case 
             when b.nr_planoconta like '01.03.001.0%' then sum(d.vl_saldo)
             when a.id_planoconta = '57-1' then sum((a.vl_saldo) + (  select sum(vl_saldo) from lanc
                                                                      where id_planoconta = '35-1' and vl_saldo > 0 
                                                                      and ch_excluido is null  ))
             when b.nr_planoconta not like '01.03.001.0%' then sum(a.vl_saldo)
           end as "saldo"
         from lanc as a
         left join planoconta as b on (a.id_planoconta = b.id_planoconta)
         left join cartaotef as c on (b.id_planoconta = c.id_planoconta)
         left join concirecpag as d on (c.id_cartaotef = d.id_cartaotef)
         left join empresa as g on (a.id_filial = g.id_filial)
            where b.ch_cont_baixa = 'T'
            and b.nr_planoconta like '01.03.%'
            and a.ch_excluido is null 
            and d.ch_excluido is null
            and a.ch_situac = 'A' or d.ch_situac = 'A'
            and b.ch_excluido is null
            and a.ch_ativo = 'T'
            and b.ch_ativo = 'T'


{if param_empresa} and g.id_filial in (:Empresa) {endif}  
{if param_conta} and b.id_planoconta in (:Conta) {endif}
{if param_emissao} and a.dh_lanc between :Posicao_ini and :Posicao_fim {endif}
  
group by a.id_planoconta, c.id_planoconta, b.nr_planoconta, b.ds_planoconta
order by 2

) x
where x.codigo <> '35-1'