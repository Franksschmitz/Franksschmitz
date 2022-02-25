-- DADOS REVENDEDOR

SELECT
    a.id_empresa,
    b.ds_entidade AS RAZAO,
    b.ds_cpfcnpj AS CNPJ,
    c.ds_endereco AS ENDERECO,
    c.ds_numero AS NUMERO,
    c.ds_bairro AS BAIRRO,
    d.ds_cidade AS CIDADE,
    e.ds_sigla AS SIGLA
FROM empresa a 
LEFT JOIN entidade b ON (a.id_entidade = b.id_entidade)
LEFT JOIN entidade_endereco c ON (a.id_entidade = c.id_entidade)
LEFT JOIN cidade d ON (c.id_cidade = d.id_cidade)
LEFT JOIN estado e ON (c.id_estado = e.id_estado)
    WHERE a.ch_excluido IS NULL
    AND c.ch_excluido IS NULL

{IF param_empresa} AND a.id_empresa IN (:EMPRESA) {ENDIF}


-- DADOS RECEBIMENTO

SELECT
    a.id_filial,
    a.id_nft,
    a.dt_saicheg AS DATA_COLETA,
    a.nr_notafi AS NR_NOTA,
    a.id_entidade,
    c.ds_entidade AS DISTRIBUIDOR,
    c.ds_cpfcnpj AS CNPJ_DIST,
    b.id_item,
    e.ds_item AS COMBUSTIVEL,
    b.qt_movest AS QUANTIDADE,
    a.id_transp,
    d.ds_entidade AS TRANSPORTADOR,
    d.ds_cpfcnpj AS CNPJ_TRANSP,
    :PLACA AS PLACA,
    :MOTORISTA AS MOTORISTA,
    :RG_MOTORISTA AS RG_MOTORISTA,
    :ANALISTA AS ANALISTA,
    :LACRE AS LACRE
FROM nft a 
LEFT JOIN nft_item b ON (a.id_nft = b.id_nft)
LEFT JOIN entidade c ON (a.id_entidade = c.id_entidade)
LEFT JOIN entidade d ON (a.id_transp = d.id_entidade)
LEFT JOIN item e ON (b.id_item = e.id_item)
    WHERE a.ch_excluido IS NULL 
    AND b.ch_excluido IS NULL 

{IF param_empresa} AND a.id_filial IN (:EMPRESA) {ENDIF}
{IF param_nr_nota} AND a.nr_notafi IN (:NR_NOTA) {ENDIF}
    

-- RESULTADO ANALISE

SELECT
    :ASPECTO AS ASPECTO,
    :COR AS COR,
    'Densidade Relativa à 20°C/4°C:' AS UM,
    'Massa Específica à 20°C:' AS DOIS,
    'Teor de Álcool na Gasolina:' AS TRES,
    'Teor Alcóolico no AEHC:' AS QUATRO