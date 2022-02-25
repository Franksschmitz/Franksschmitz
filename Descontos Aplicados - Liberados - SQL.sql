select 
   b.id_item,
   b.ds_item,
   b.id_regrapreco,
   g.ds_regrapreco,
   vl_totdescon,
   a.id_usuario_m,
   e.ds_entidade,
   a.id_usuario_lib,
   f.ds_entidade
from docfiscal a
left join docfiscal_item b on a.id_docfiscal = b.id_docfiscal
left join usuario c on a.id_usuario_m = c.id_usuario
left join usuario d on a.id_usuario_lib = d.id_usuario
left join entidade e on c.id_entidade = e.id_entidade
left join entidade f on d.id_entidade = f.id_entidade
left join regrapreco g on b.id_regrapreco = g.id_regrapreco
   where nr_docfiscal = '86686'