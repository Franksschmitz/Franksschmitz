select
   case
      when x.COD is not null then x.COD
      when x.COD is null     then '1-1'
      when x.COD = ''        then '1-1'
   end as CODIGO,
   case
      when x.FRENT <> '1-1' then x.FRENT
      when x.FRENT = '1-1'  then 'FRENTISTA NAO IDENTIFICADO'
   end as FRENTISTA,
   x.QUANT,
   x.QT_AB,
   x.VL_AB,
   cast((100 + (x.QUANT / (select cast(count(1) as numeric(26,2)) from abastecimento s
                           left join empresa t on (s.id_empresa = t.id_empresa)
                           where s.ch_ativo = 'T' and s.ch_excluido is null
                           and s.dt_emissao between :Emissao_ini and :Emissao_fim
                           and case
                                  when t.ch_vinculada = 'T'  then t.id_filial =:Empresa
                                  when t.ch_vinculada <> 'T' then t.id_empresa =:Empresa
                               end) - 1 ) * 100) as numeric(26,2)) PERCENTUAL
from (
        select
	       e.id_entidade as COD,
           e.ds_entidade FRENT,
	       count(a.id_abastecimento) QUANT,
           sum(a.qt_abastecimento) QT_AB,
	       sum(a.vl_abastecimento) VL_AB		   
        from abastecimento a
	    left join rfid f on (a.id_rfid_operador = f.id_rfid)
	    left join item d on (a.id_item = d.id_item)
	    left join entidade e on (f.id_entidade = e.id_entidade)
	    left join empresa g on (a.id_empresa = g.id_empresa)
		   where f.id_entidade = e.id_entidade
           and a.ch_excluido is null
		   and a.ch_ativo = 'T' 

		{if param_Empresa} and case 
				    	         when g.ch_vinculada = 'T'  then g.id_filial =:Empresa   
					             when g.ch_vinculada <> 'T' then g.id_empresa =:Empresa  
				               end {endif}
		{if param_Frentista} and e.id_entidade in (:Frentista) {endif} 
        {if param_emissao_ini} and a.dt_emissao between :Emissao_ini and :Emissao_fim {endif}
		group by 1,2
		order by 3 desc
				
) x