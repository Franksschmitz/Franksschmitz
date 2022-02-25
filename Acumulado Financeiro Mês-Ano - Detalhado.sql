select 
    x.empresa,
	x.ano,
	x.codigo,
	x.item,
	x.cod,
	x.grupo,
	cast(sum(x.jan) as numeric(22,3)) JANEIRO,
	cast(sum(x.fev) as numeric(22,3)) FEVEREIRO,
	cast(sum(x.mar) as numeric(22,3)) MARCO,
	cast(sum(x.abr) as numeric(22,3)) ABRIL,
	cast(sum(x.mai) as numeric(22,3)) MAIO,
	cast(sum(x.jun) as numeric(22,3)) JUNHO,
	cast(sum(x.jul) as numeric(22,3)) JULHO,
	cast(sum(x.ago) as numeric(22,3)) AGOSTO,
	cast(sum(x.sete) as numeric(22,3)) SETEMBRO,
	cast(sum(x.outu) as numeric(22,3)) OUTUBRO,
	cast(sum(x.nov) as numeric(22,3)) NOVEMBRO,
	cast(sum(x.dez) as numeric(22,3)) DEZEMBRO,
	cast(sum(x.total_ano) as numeric(22,3)) TOTAL
from (
		select
			a.id_filial EMPRESA,
			b.id_item CODIGO,
			c.ds_item ITEM,
			extract(year from a.dt_emissa) ANO,
			c.id_grupoitem cod,
			d.ds_grupoitem GRUPO,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '01') JAN,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '02') FEV,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '03') MAR,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '04') ABR,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '05') MAI,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '06') JUN,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '07') JUL,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '08') AGO,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '09') SETE,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '10') OUTU,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '11') NOV,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(month from a.dt_emissa) = '12') DEZ,
			(select sum(z.vl_total) from docfiscal_item z 
			where z.id_empresa = a.id_filial 
			and z.id_item = b.id_item 
			and z.id_docfiscal_item = b.id_docfiscal_item
			and z.ch_excluido is null
			and extract(year from a.dt_emissa) between :Ano and :Ate) TOTAL_ANO
		from docfiscal a 
		left join docfiscal_item b on (a.id_docfiscal = b.id_docfiscal)
		left join item c on (b.id_item = c.id_item)
		left join grupoitem d on (c.id_grupoitem = d.id_grupoitem)
		where a.ch_situac = 'F'
		and a.ch_sitpdv = 'F'
		and b.ch_excluido is null
		
		
		{if param_id_filial} and a.id_filial in (:Empresa) {endif}
        {if param_id_item} and c.id_item in (:Item) {endif}
        {if param_grupoitem} and d.id_grupoitem in (:GrupoItem) {endif}
		{if param_ano} and extract(year from a.dt_emissa) between :Ano and :Ate {endif}

) x

group by 1,2,3,4,5,6
order by 2,3