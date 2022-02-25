WITH grupo AS (
	select 
		g1.id_grupoitem,
		coalesce(g2.id_grupoitem, g1.id_grupoitem) as id_grupo,
		coalesce(g2.ds_grupoitem, g1.ds_grupoitem) as ds_grupo,
		case when coalesce(g2.ds_grupoitem, g1.ds_grupoitem) ilike '%bebid%' then 1
			when coalesce(g2.ds_grupoitem, g1.ds_grupoitem) ilike '%lubrificante%' then 2
			when coalesce(g2.ds_grupoitem, g1.ds_grupoitem) ilike '%padari%' then 3
			else 0 end tipo_grupo
	from grupoitem as g1
	LEFT JOIN grupoitem as g2 on (g2.id_grupoitem = g1.id_pai )
	where coalesce(g2.id_grupoitem, g1.id_grupoitem) IN (:GrupoItem)
	and g1.ch_excluido is null
), 
vendas as (

SELECT
	CASE
		WHEN h.ch_vinculada <> 'T' THEN a.id_filial
		ELSE h.id_filial
	END AS EMPRESA,
	CASE
		WHEN b.id_vendedor is NULL THEN d.id_entidade
		WHEN b.id_vendedor IS NULL THEN d.id_entidade
		ELSE b.id_vendedor
	END AS COD,
	CASE
		WHEN b.id_vendedor = NULL THEN d.ds_entidade
		WHEN b.id_vendedor IS NULL THEN d.ds_entidade
		ELSE e.ds_entidade
	END AS VENDEDOR,
	g.id_grupo AS COD_GRUPO,
	g.ds_grupo AS GRUPO,
	g.tipo_grupo,
	SUM(b.qt_item) AS QTD,
	SUM(b.vl_total) AS VALOR
FROM docfiscal a 
LEFT JOIN docfiscal_item b ON a.id_docfiscal = b.id_docfiscal 
LEFT JOIN usuario c ON a.id_usuario = c.id_usuario
LEFT JOIN entidade d ON c.id_entidade = d.id_entidade
LEFT JOIN entidade e ON b.id_vendedor = e.id_entidade
inner JOIN item f ON b.id_item = f.id_item
inner JOIN grupo g ON f.id_grupoitem = g.id_grupoitem 
LEFT JOIN empresa h ON a.id_filial = h.id_empresa
	WHERE a.ch_situac = 'F'
	AND (a.dt_emissa between :dataIni AND :dataFim)
	AND a.ch_sitpdv = 'F'
	AND a.ch_tipo <> 'NFE'
	AND b.ch_excluido IS NULL

GROUP BY 1,2,3,4,5,6
ORDER BY 1,3,5
), 
	vendas_peso AS (
	
	select
		v.*,
		case when tipo_grupo = 1 and qtd >= 34 then 3
		when tipo_grupo = 1 and qtd >= 26 then 2
		when tipo_grupo = 1 and qtd >= 1 then 1
		when tipo_grupo = 2 then 0.75
		when tipo_grupo = 3 then 1
		else 0 end valor_peso
	from vendas as v
)

select 
	vp.empresa,
    ep.ds_empresa,
	vp.cod as cod_vendedor,
	vp.vendedor,
	vp.cod_grupo,
	vp.grupo,
	vp.qtd as quantidade,
	case 
        when valor_peso > 0 then (qtd * valor_peso) 
        else 0 
    end as valor_comissao
from vendas_peso as vp
left join empresa ep on vp.empresa = ep.id_empresa
    where vp.empresa in (:Empresa)

order by 
1,4,6