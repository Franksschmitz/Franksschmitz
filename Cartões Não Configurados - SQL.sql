SELECT
    *
FROM (

        SELECT 
            t.dh_emissao AS EMISSAO,  
            CASE 
                WHEN emp.ch_vinculada = 'T' THEN emp.id_filial
                ELSE t.id_empresa
            END AS EMPRESA, 
            'Doc. Venda N°' || ' ' || CAST(d.nr_docfiscal AS VARCHAR) AS ORIGEM, 
            CASE
                WHEN t.ds_carteiradig IS NOT NULL THEN t.ds_carteiradig
                ELSE t.ds_cartao
            END AS CARTAO, 
            t.nr_nsu AS NSU, 
            t.ds_tipo_ope AS TIPO, 
            t.nr_operatef AS NR_OPE, 
            CASE
                WHEN t.nr_carteiradig IS  NOT  NULL THEN t.nr_carteiradig
                ELSE t.nr_bandeira
            END AS NR_BAND,
            o.ds_operatef AS DS_OPE, 
            t.vl_valor AS VALOR
        FROM tef_ope t
        LEFT JOIN operatef AS o ON o.ID_OPERATEF = t.ID_OPERATEF
        LEFT JOIN tef e ON t.id_tef=e.id_tef
        LEFT JOIN docfiscal d ON e.id_docfiscal=d.id_docfiscal
        LEFT JOIN empresa emp ON t.id_empresa = emp.id_empresa
            WHERE t.id_cartaotef = '1-1' 
            AND t.ch_excluido IS NULL
            AND t.ch_situac = 'F'
            AND e.id_docfiscal IS NOT NULL
            


    UNION ALL


        SELECT 
            a.dh_emissao AS EMISSAO,  
            CASE 
                WHEN emp.ch_vinculada = 'T' THEN emp.id_filial
                ELSE a.id_empresa
            END AS EMPRESA, 
            CAST('RECEBIMENTO/TROCA DE VALORES' AS VARCHAR) AS ORIGEM, 
            CASE
                WHEN a.ds_carteiradig IS NOT NULL THEN a.ds_carteiradig
                ELSE a.ds_cartao
            END AS CARTAO, 
            a.nr_nsu AS NSU, 
            a.ds_tipo_ope AS TIPO, 
            a.nr_operatef AS NR_OPE, 
            CASE
                WHEN a.nr_carteiradig IS  NOT  NULL THEN a.nr_carteiradig
                ELSE a.nr_bandeira
            END AS NR_BAND,
            b.ds_operatef AS DS_OPE, 
            a.vl_valor AS VALOR
        FROM tef_ope a
        LEFT JOIN operatef AS b ON a.ID_OPERATEF = b.ID_OPERATEF
        LEFT JOIN tef c ON a.id_tef = c.id_tef
        LEFT JOIN docfiscal g ON c.id_docfiscal = g.id_docfiscal
        LEFT JOIN empresa emp ON a.id_empresa = emp.id_empresa
            WHERE a.id_cartaotef = '1-1' 
            AND a.ch_excluido IS NULL
            AND a.ch_situac = 'F'
            AND c.id_rectopagto IS NOT NULL
            


) s
  
{IF param_id_empresa} WHERE s.empresa IN (:id_empresa){ENDIF}
{IF param_emissao_ini} AND CAST(s.emissao AS DATE) BETWEEN :emissao_ini AND:emissao_fim {ENDIF}
{IF param_valor_ini} AND s.valor BETWEEN :valor_ini AND :valor_fim {ENDIF}
{IF param_ordem_Empresa} ORDER BY s.empresa {ENDIF}
{IF param_ordem_Valor} ORDER BY s.valor {ENDIF}
{IF param_ordem_Emissão} ORDER BY s.emissao {ENDIF}
