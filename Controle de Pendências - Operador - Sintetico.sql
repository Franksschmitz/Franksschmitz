SELECT
    x.empresa,
    x.operador,
    SUM(x.sobra) AS VALOR_SOBRA,
    SUM(x.falta) AS VALOR_FALTA,
    SUM(x.baixa) AS VALOR_BAIXA
FROM (

            SELECT
                l.id_filial || ' - ' || ep.ds_EMPRESA AS EMPRESA,
                e.ds_entidade AS OPERADOR,
                SUM(cfu.vl_sobra) AS SOBRA,
                SUM(0) AS FALTA,
                SUM(0) AS BAIXA
            FROM lanc l
            LEFT JOIN caixapdv_fec cf ON l.id_caixapdv_fec = cf.id_caixapdv_fec
            LEFT JOIN caixapdv_fecusu cfu ON cf.id_caixapdv_fec = cfu.id_caixapdv_fec
            LEFT JOIN usuario u ON cfu.id_usuario = u.id_usuario
            LEFT JOIN entidade e ON u.id_entidade = e.id_entidade
            LEFT JOIN caixapdv cp ON cf.id_caixapdv = cp.id_caixapdv
            LEFT JOIN caixacfg cc ON cp.id_caixacfg = cc.id_caixacfg
            LEFT JOIN empresa ep ON l.id_filial = ep.id_empresa
                WHERE l.id_planoconta IN ( SELECT id_planoconta FROM planoconta WHERE ds_planoconta = 'SOBRA DE CAIXA' AND ch_ativo = 'T' AND ch_excluido IS NULL )
                AND l.ch_excluido IS NULL
                AND cf.ch_excluido IS NULL
                AND cfu.ch_excluido IS NULL
                AND cfu.vl_sobra > 0
                AND l.id_filial IN (:Empresa)
                AND cfu.id_usuario IN (:Operador)
                AND l.dh_lanc BETWEEN :Data_ini AND CAST((:Data_fim || ' 23:59:59') AS TIMESTAMP)

            GROUP BY 1,2

        UNION ALL

            SELECT
                l.id_filial || ' - ' || ep.ds_EMPRESA AS EMPRESA,
                e.ds_entidade AS OPERADOR,
                SUM(0) AS SOBRA,
                SUM(- (cfu.vl_falta)) AS FALTA,
                SUM(0) AS BAIXA
            FROM lanc l
            LEFT JOIN caixapdv_fec cf ON l.id_caixapdv_fec = cf.id_caixapdv_fec
            LEFT JOIN caixapdv_fecusu cfu ON cf.id_caixapdv_fec = cfu.id_caixapdv_fec
            LEFT JOIN usuario u ON cfu.id_usuario = u.id_usuario
            LEFT JOIN entidade e ON u.id_entidade = e.id_entidade
            LEFT JOIN caixapdv cp ON cf.id_caixapdv = cp.id_caixapdv
            LEFT JOIN caixacfg cc ON cp.id_caixacfg = cc.id_caixacfg
            LEFT JOIN empresa ep ON l.id_filial = ep.id_empresa
                WHERE l.id_planoconta IN ( SELECT id_planoconta FROM planoconta WHERE ds_planoconta = 'FALTA DE CAIXA' AND ch_ativo = 'T' AND ch_excluido IS NULL )
                AND l.ch_excluido IS NULL
                AND cf.ch_excluido IS NULL
                AND cfu.ch_excluido IS NULL
                AND cfu.vl_falta > 0
                AND l.id_filial IN (:Empresa)
                AND cfu.id_usuario IN (:Operador)
                AND l.dh_lanc BETWEEN :Data_ini AND CAST((:Data_fim || ' 23:59:59') AS TIMESTAMP)

            GROUP BY 1,2

        UNION ALL

            SELECT
                l.id_filial || ' - ' || ep.ds_EMPRESA AS EMPRESA,
                e.ds_entidade AS OPERADOR,
                SUM(0) AS SOBRA,
                SUM(0) AS FALTA,
                SUM(l.vl_valor) AS BAIXA
            FROM lanc l
            LEFT JOIN entidade e ON l.id_entidade = e.id_entidade
            LEFT JOIN empresa ep ON l.id_filial = ep.id_empresa
                WHERE l.id_tipolanc = '95-1'
                AND l.ch_excluido IS NULL
                AND l.id_planoconta IN ( SELECT id_planoconta FROM planoconta WHERE ds_planoconta = 'FALTA DE CAIXA' AND ch_ativo = 'T' AND ch_excluido IS NULL )
                AND l.id_filial IN (:Empresa)
                AND l.id_entidade IN ( SELECT id_entidade FROM usuario WHERE id_usuario IN (:Operador) )
                AND l.dh_lanc BETWEEN :Data_ini AND CAST((:Data_fim || ' 23:59:59') AS TIMESTAMP)

            GROUP BY 1,2

 ) x

GROUP BY 1,2
ORDER BY 1,2