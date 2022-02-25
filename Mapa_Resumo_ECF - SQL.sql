select 
   eqp.ds_fabric as SERIE, 
   de.nr_crz as CRZ, 
   de.nr_coo as COO, 
   de.dt_movime as DATA_MOV, 
   de.dt_emissao as EMISSAO, 
   de.hr_emissao as HORARIO, 
   de.nr_cooini as CUPOM_INI,
   de.nr_coofim CUPOM_FIM, 
   de.vl_brutadia as VENDA_BRUTA, 
   de.vl_grandetotal as GRANDE_TOTAL, 
   ds_totalizador as Totalizador,
   case
	 when dd.ds_totalizador = 'F1' then 'VALOR ST'
	 when dd.ds_totalizador = 'Can-T' then 'CANCELAMENTOS'
	 when dd.ds_totalizador = 'I1' then 'ISENTO'
	 when dd.ds_totalizador = 'N1' then 'NÃO TRIB.'
	 when dd.ds_totalizador = 'IS1' then 'SERVIÇOS ISENTO'
	 when dd.ds_totalizador = 'NS1' then 'SERVIÇOS NÃO TRIB.'
	 when dd.ds_totalizador = 'FS1' then 'SERVIÇOS ST'
	 when dd.ds_totalizador = 'DT' then 'DESCONTOS'
	 when dd.ds_totalizador = 'AT' then 'ACRÉSCIMOS'
	 when dd.ds_totalizador = 'DS' then 'DESCONTOS SERV.'
	 when dd.ds_totalizador = 'AS' then 'ACRÉSCIMOS SERV.'
	 when dd.ds_totalizador = 'Can-S' then 'CANC. SERV.'
	 when dd.ds_totalizador = 'AT' then 'ACRÉSCIMOS'
	 when dd.ds_totalizador like '%0500%' then 'B.CALC. 5%'
	 when dd.ds_totalizador like '%0700%' then 'B.CALC. 7%'
	 when dd.ds_totalizador like '%1200%' then 'B.CALC. 12%'
	 when dd.ds_totalizador like '%1700%' then 'B.CALC. 17%'
	 when dd.ds_totalizador like '%2500%' then 'B.CALC. 25%'
   end DS_Totalizador,
   dd.vl_totalizador as VALOR
from docecf de
left join docecf_det dd on (de.id_docecf=dd.id_docecf)
left join eqpecf eqp on (de.id_eqpecf=eqp.id_eqpecf)
 where de.ds_tipo='RZ' 
 and de.ch_excluido is null 
 and dd.ch_excluido is null 
 and dd.vl_totalizador!='0'

  {if param_id_filial} and de.id_filial in (:id_filial) {endif}
  {if param_emissao_ini} and de.dt_emissao between :emissao_ini and :emissao_fim {endif}

order by de.dt_movime