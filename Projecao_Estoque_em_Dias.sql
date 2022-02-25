/* EXEMPLO
		ESTOQUE: 123
		PERIODO: 98
		VENDA PER.: 68
		123 / (68 / 98) = 2,5
		ESTOQUE PARA MAIS 177 DIAS
		FORMULA: estoque / (qt_venda_periodo / periodo) = dias_estoque
FIM DO EXEMPLO */


select 
	s.ds_item as "Item",
	s.estoque as "Estoque Atual",
	s.qt_venda as "Qt. Venda",
  	case 
  		when floor((s.estoque / (s.qt_venda / :periodo))) <= 0 
  		or s.estoque is null then '0 Dias'
		else floor((s.estoque / (s.qt_venda / :periodo))) || ' Dias' 
	end as "Estoque Para",
	case
		when floor((s.estoque / (s.qt_venda / :periodo))) <= 0 
  		or s.estoque is null then current_date
  		else (current_date + cast(floor((s.estoque / (s.qt_venda / :periodo))) as integer))
	end as "Estoque Até", 
	s.ds_empresa as "Empresa"
from 
	(
		select 
			i.ds_item,
			(select
				sum(sli.qt_estoque)
			from localarm sla
			left join localarm_item sli on (sla.id_localarm = sli.id_localarm)
			where sli.id_item = i.id_item) as estoque,
			sum(di.qt_item) as qt_venda,
			e.ds_empresa
		from item i
		join docfiscal_item di on (i.id_item = di.id_item)
		join docfiscal df on (di.id_docfiscal = df.id_docfiscal)
		join empresa e on (df.id_empresa = e.id_empresa)
		where df.ch_excluido is null
		and i.ch_excluido is null
		and df.dt_emissa > cast(current_date - cast(:periodo as integer)as date)			
			{if param_id_empresa} and df.id_empresa in (:id_empresa) {endif}
			{if param_id_grupoitem} and i.id_grupoitem in (:id_grupoitem) {endif}
			{if param_id_item} and i.id_item in (:id_item) {endif}
		group by i.id_item, i.ds_item, e.ds_empresa
		order by i.ds_item
) s





















