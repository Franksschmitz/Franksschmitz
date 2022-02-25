select
   x.emp,
   x.empresa,
   x.cod,
   x.item,
   x.dia,
   x.custo,
   x.venda,
   cast((x.venda - x.custo)as numeric(26,3)) MARGEM,
   cast ((((x.venda / x.custo)  - 1 ) * 100) as numeric(26,3)) PERCENTUAL
from (   
			select
			   case
				  when e.ch_vinculada = 'T'    then e.id_filial
				  else d.id_filial
			   end EMP,
			   e.ds_empresa EMPRESA,
			   a.id_item COD,
			   b.ds_item ITEM,
			   d.dt_emissa DIA,
			   max(a.vl_precus) CUSTO,
			   max(a.vl_unitar) VENDA
			from docfiscal d
			left join docfiscal_item a on (d.id_docfiscal = a.id_docfiscal)
			left join item b on (a.id_item = b.id_item)
			left join empresa e on (d.id_filial = e.id_empresa)
			 where a.id_regrapreco is null
			 and a.id_regrapreco_apl is null
			 and a.ch_excluido is null
			 and a.vl_precus <> '0'
			 
			{if param_empresa} and case 
			                         when e.ch_vinculada = 'T'    then e.id_filial
                                     else d.id_filial 
								   end in (:Empresa) {endif}
			{if param_grupoitem} and b.id_grupoitem in (:GrupoItem) {endif}						   
            {if param_item} and b.id_item in (:Item) {endif}	
			{if param_emissao_ini} and d.dt_emissa between :Emissao_ini and :Emissao_fim {endif}
			
			group by 1,2,3,4,5
			order by 1,4,5
) x