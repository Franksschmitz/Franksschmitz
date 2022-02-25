SELECT
    y.cod,
    y.ent,
    y.tipo,
    y.emp,
    y.bloq,
    y.esp,
    y.situac,
    y.lim,
    y.uti,
    y.saldo,
    CASE
        WHEN y.stat = '3' THEN 'Limite Indisponivel'
        WHEN y.stat = '1' THEN 'Limite Disponivel'
        WHEN y.stat = '2' THEN 'Limite Excedido'
    END AS STATUS
FROM (
        SELECT
            x.cod,
            x.ent,
            CASE
                WHEN x.ch_tipo = 'G' THEN 'GERAL'
                ELSE 'EMP.'
            END AS TIPO,
            x.emp,
            CASE
                WHEN x.ch_especie = 'T' THEN 'SIM'
                ELSE 'NAO'
            END AS BLOQ,
            x.esp,
            CASE
                WHEN (x.lim - x.utili) < 0  THEN 'BLOQUEADO'
                WHEN x.ch_sitcre = 'A'      THEN 'APROVADO'
                WHEN x.ch_sitcre = 'B'      THEN 'BLOQUEADO'
                WHEN x.ch_sitcre = 'D'      THEN 'DESBLOQUEADO'
            END AS SITUAC,
            CAST(x.lim AS NUMERIC(25,3)),
            CASE
                WHEN x.utili = NULL     THEN '0'
                WHEN x.utili IS NULL    THEN '0'
                ELSE x.utili
            END AS UTI,
            CASE
                WHEN x.utili = NULL         THEN x.lim
                WHEN x.utili IS NULL        THEN x.lim
                WHEN x.lim - x.utili = NULL THEN x.lim
                WHEN x.lim - x.utili = 0    THEN x.lim
                ELSE x.lim - x.utili
            END AS SALDO,
            CAST((CASE
                    WHEN x.ch_sitcre = 'B'      THEN '3'
                    WHEN (x.lim - x.utili) = 0  THEN '3'
                    WHEN (x.lim - x.utili) > 0  THEN '1'
                    WHEN (x.lim - x.utili) < 0  THEN '2'
                    ELSE '1'
            END) AS NUMERIC(1)) AS STAT
            FROM (
                    SELECT  
                        b.id_entidade AS COD,
                        a.ds_entidade AS ENT,
                        b.ch_tipo,
                        CASE 
                            WHEN b.ch_tipo = 'G' THEN 'TODAS'
                            ELSE e.id_empresa || ' - ' || e.ds_empresa
                        END AS EMP,
                        b.ch_especie,
                        CASE 
                            WHEN b.id_especie IS NOT NULL THEN d.ds_especie
                            ELSE 'TODAS'
                        END AS ESP,
                        b.ch_sitcre,
                        b.vl_limcre AS LIM,
                        CASE
                            WHEN b.id_especie = NULL AND b.id_filial IS NOT NULL THEN (SELECT CASE WHEN (SUM(vl_saldo)) = NULL THEN 0 ELSE SUM(vl_saldo) END FROM lanc WHERE id_entidade = b.id_entidade AND id_filial = b.id_filial AND ch_excluido IS NULL AND id_especie IN (SELECT id_especie FROM especie WHERE ch_limcre = 'T'))
                            WHEN b.id_especie IS NULL AND b.id_filial IS NOT NULL THEN (SELECT CASE WHEN (SUM(vl_saldo)) = NULL THEN 0 ELSE SUM(vl_saldo) END FROM lanc WHERE id_entidade = b.id_entidade AND id_filial = b.id_filial AND ch_excluido IS NULL AND id_especie IN (SELECT id_especie FROM especie WHERE ch_limcre = 'T'))
                            WHEN b.id_especie IS NULL THEN (SELECT CASE WHEN (SUM(vl_saldo)) = NULL THEN 0 ELSE SUM(vl_saldo) END FROM lanc WHERE id_entidade = b.id_entidade AND ch_excluido IS NULL AND id_especie IN (SELECT id_especie FROM especie WHERE ch_limcre = 'T'))
                            WHEN b.id_especie = NULL THEN (SELECT CASE WHEN (SUM(vl_saldo)) = NULL THEN 0 ELSE SUM(vl_saldo) END FROM lanc WHERE id_entidade = b.id_entidade AND ch_excluido IS NULL AND id_especie IN (SELECT id_especie FROM especie WHERE ch_limcre = 'T'))
                            WHEN b.id_filial IS NULL THEN (SELECT CASE WHEN (SUM(vl_saldo)) = NULL THEN 0 ELSE SUM(vl_saldo) END FROM lanc WHERE ch_situac = 'A' AND vl_saldo > 0 AND id_entidade = b.id_entidade AND id_especie = b.id_especie AND ch_excluido IS NULL)
                            WHEN b.id_filial = NULL THEN (SELECT CASE WHEN (SUM(vl_saldo)) = NULL THEN 0 ELSE SUM(vl_saldo) END FROM lanc WHERE ch_situac = 'A' AND vl_saldo > 0 AND id_entidade = b.id_entidade AND id_especie = b.id_especie AND ch_excluido IS NULL)
                            ELSE (SELECT CASE WHEN (SUM(vl_saldo)) = NULL THEN 0 ELSE SUM(vl_saldo) END FROM lanc WHERE ch_situac = 'A' AND vl_saldo > 0 AND id_entidade = b.id_entidade AND id_especie = b.id_especie AND id_filial = b.id_filial AND ch_excluido IS NULL)
                        END AS UTILI
                    FROM entidade_cred b
                    LEFT JOIN entidade a ON (b.id_entidade = a.id_entidade)
                    LEFT JOIN especie d ON (b.id_especie = d.id_especie)
                    LEFT JOIN grupoentidade c ON (a.id_grupoentidade = c.id_grupoentidade)
                    LEFT JOIN empresa e ON (b.id_filial = e.id_empresa)
                        WHERE b.id_entidade = a.id_entidade
                        AND b.ch_excluido IS NULL
                        AND a.ch_ativo = 'T'
                        AND a.ch_excluido IS NULL
                        
                    {IF PARAM_Grupo} AND c.id_grupoentidade IN (:Grupo) {ENDIF}
                    {IF PARAM_Entidade} AND b.id_entidade IN (:Entidade) {ENDIF}
                    {IF PARAM_Especie} AND b.id_especie IN (:Especie) {ENDIF}
                    {IF PARAM_Limite} AND b.vl_limcre BETWEEN :Limite AND :Ate {ENDIF}
                    {IF PARAM_Situacao} AND b.ch_sitcre IN (CASE
                                                                WHEN (:Situacao) = 'A' THEN 'A'
                                                                WHEN (:Situacao) = 'B' THEN 'B'
                                                                WHEN (:Situacao) = 'D' THEN 'D'
                                                                WHEN (:Situacao) = 'd' THEN 'D'
                                                                WHEN (:Situacao) = 'b' THEN 'B'
                                                                WHEN (:Situacao) = 'a' THEN 'A'
                                                            END ) {ENDIF}

                ) x

) y

WHERE (CASE
            WHEN (:Stat) = 'I'   THEN y.stat = 3
            WHEN (:Stat) = 'E'   THEN y.stat = 2
            WHEN (:Stat) = 'D'   THEN y.stat = 1
            WHEN (:Stat) = 'd'   THEN y.stat = 1
            WHEN (:Stat) = 'e'   THEN y.stat = 2
            WHEN (:Stat) = 'i'   THEN y.stat = 3
            ELSE y.stat BETWEEN 1 AND 3
        END)

ORDER BY 2,4

{IF param_ordem_Entidade} ORDER BY y.ent {ENDIF}
{IF param_ordem_Maior_Limite} ORDER BY y.lim DESC {ENDIF}
{IF param_ordem_Menor_Limite} ORDER BY y.lim ASC {ENDIF}