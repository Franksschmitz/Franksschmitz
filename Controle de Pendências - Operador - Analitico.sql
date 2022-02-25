SELECT
    x.datahora,
    x.empresa,
    x.caixa,
    x.operador,
    CASE
        WHEN x.tipo = 'SOBRA DE CAIXA'      THEN 1
        WHEN x.tipo = 'FALTA DE CAIXA'      THEN 2
        WHEN x.tipo = 'BAIXA DE PENDÊNCIA'  THEN 3
    END AS TP,
    x.tipo,
    x.valor
FROM (

            SELECT
                l.dh_lanc AS DATAHORA,
                l.id_filial || ' - ' || ep.ds_EMPRESA AS EMPRESA,
                cp.id_caixapdv || ' ' || cc.ds_caixacfg || ' - ' || 'TURNO' || ' ' || cp.nr_turno AS CAIXA,
                e.ds_entidade AS OPERADOR,
                'SOBRA DE CAIXA' AS TIPO,
                cfu.vl_sobra AS VALOR
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

            {IF param_Empresa} AND l.id_filial IN (:Empresa) {ENDIF}
            {IF param_Operador} AND cfu.id_usuario IN (:Operador) {ENDIF}
            {IF param_Data_ini} AND l.dh_lanc BETWEEN :Data_ini AND CAST((:Data_fim || ' 23:59:59') AS TIMESTAMP) {ENDIF}


        UNION ALL


            SELECT
                l.dh_lanc AS DATAHORA,
                l.id_filial || ' - ' || ep.ds_EMPRESA AS EMPRESA,
                cp.id_caixapdv || ' ' || cc.ds_caixacfg || ' - ' || 'TURNO' || ' ' || cp.nr_turno AS CAIXA,
                e.ds_entidade AS OPERADOR,
                'FALTA DE CAIXA' AS TIPO,
                - (cfu.vl_falta) AS VALOR
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

            {IF param_Empresa} AND l.id_filial IN (:Empresa) {ENDIF}
            {IF param_Operador} AND cfu.id_usuario IN (:Operador) {ENDIF}
            {IF param_Data_ini} AND l.dh_lanc BETWEEN :Data_ini AND CAST((:Data_fim || ' 23:59:59') AS TIMESTAMP) {ENDIF}


        UNION ALL


            SELECT
                l.dh_lanc AS DATAHORA,
                l.id_filial || ' - ' || ep.ds_EMPRESA AS EMPRESA,
                '' AS CAIXA,
                e.ds_entidade AS OPERADOR,
                'BAIXA DE PENDÊNCIA' AS TIPO,
                l.vl_valor AS VALOR
            FROM lanc l
            LEFT JOIN entidade e ON l.id_entidade = e.id_entidade
            LEFT JOIN empresa ep ON l.id_filial = ep.id_empresa
                WHERE l.id_tipolanc = '95-1'
                AND l.ch_excluido IS NULL
                AND l.id_planoconta IN ( SELECT id_planoconta FROM planoconta WHERE ds_planoconta = 'FALTA DE CAIXA' AND ch_ativo = 'T' AND ch_excluido IS NULL )
                AND l.id_entidade IN ( SELECT id_entidade FROM usuario WHERE id_usuario IN (:Operador))


            {IF param_Empresa} AND l.id_filial IN (:Empresa) {ENDIF}
            {IF param_Data_ini} AND l.dh_lanc BETWEEN :Data_ini AND CAST((:Data_fim || ' 23:59:59') AS TIMESTAMP) {ENDIF}

) x

ORDER BY 1