SELECT
  i.id_invent AS ID,
  e.ds_empresa AS Empresa, 
  l.ds_localarm AS Deposito, 
  i.dt_emissa AS Emissao, 
  i.dh_finaliza AS Finalizado,
  ii.id_item AS ID_item, 
  it.ds_item AS Item, 
  ii.qt_estoque AS QT_Estoque, 
  ii.QT_Leitura AS QT_Coletada, 
  ii.qt_item AS QT_Digitada,
  ii.dh_leitura AS DT_Leitura,
  (ii.qt_item - ii.qt_estoque) AS diferenca,
  CASE
     WHEN ch_situac = 'F' THEN 'FINALIZADO'
     WHEN ch_situac = 'C' THEN 'CANCELADO'
     WHEN ch_situac = 'P' THEN 'PENDENTE'
  END AS Situacao
FROM invent i
LEFT JOIN invent_item ii ON (i.id_invent = ii.id_invent)
LEFT JOIN item it ON (ii.id_item = it.id_item)
LEFT JOIN grupoitem gi ON (it.id_grupoitem = gi.id_grupoitem)
LEFT JOIN localarm l ON (i.id_localarm = l.id_localarm)
LEFT JOIN empresa e ON (i.id_filial = e.id_empresa)
    WHERE i.ch_tipo='I' 
    AND i.ch_excluido IS NULL 
    AND ii.ch_excluido IS NULL 

{IF param_Empresa} AND i.id_filial IN (:Empresa) {ENDIF}
{IF param_GrupoItem} AND gi.id_grupoitem IN (:GrupoItem) {ENDIF}
{IF param_Item} AND ii.id_item IN (:Item) {ENDIF}
{IF param_Inventario} AND i.id_invent IN (:Inventario) {ENDIF}
{IF param_emissao_ini} AND i.dt_emissa BETWEEN :emissao_ini AND :emissao_fim {ENDIF}

ORDER BY 4,1,12