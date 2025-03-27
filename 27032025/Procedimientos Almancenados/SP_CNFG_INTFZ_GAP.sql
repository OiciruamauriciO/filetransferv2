create or replace PROCEDURE             "SP_CNFG_INTFZ_GAP" (

    p_s_detalle IN VARCHAR2,
    p_s_fecha IN VARCHAR2,
    p_c_datos OUT SYS_REFCURSOR,
    p_c_salida OUT SYS_REFCURSOR
) AS
    /*************************************************************************************************
     Procedimiento: SP_CNFG_INTFZ_GAP
     HU           : J00102-5942
     Objetivo:      Servicio que tiene propósito principal permitir la consulta de información
     relacionada con GAP mediante la especificación de fechas

     Sistema:       CNFCG
     Base de Datos: CONFIG_GLOBAL_DBO
     Tablas Usadas: CNFGS_DT_OPRCN
     Fecha:         20-11-2024
     Autor:         Andres Diaz - Celula Ingenio
     Input:         p_s_tipo
     p_s_fecha
     Output:        p_c_datos
     p_c_salida
     Observaciones:
     REVISIONES:
     Ver        Date        Author                Description
     ---------  ----------  -------------------   ------------------------------------
     m0         20-11-2024  Andres Diaz     Version inicial
     --************************************************************************************************/
    --p_c_cursor             sys_refcursor;
    ----------------------------------
    --Variables
    ----------------------------------
    v_d_fecha NUMBER;
    v_n_retorno NUMBER;
    v_s_mensaje VARCHAR2(1000);
    v_n_contador NUMBER;
    ----------------------------------
    --Excepciones
    ----------------------------------
    e_fecha_nula EXCEPTION;
    e_fecha_invalida EXCEPTION;
    e_parametro_invalido EXCEPTION;
    ----------------------------------
    --Constantes
    ----------------------------------
    v_nro_0 CONSTANT NUMBER := 0;
    v_nro_1 CONSTANT NUMBER := 1;
    v_nro_0081 CONSTANT CHAR(4) := '0081';
    v_c_espacio CONSTANT CHAR(1) := ' ';
    v_c_positivo CONSTANT CHAR(1) := '+';
    v_c_negativo CONSTANT CHAR(1) := '-';

BEGIN

    IF p_s_fecha IS NULL OR TRIM(p_s_fecha) = '' THEN RAISE e_fecha_nula;
    END IF;

    IF NOT FN_CNFG_NUM_IDF_REG(p_s_fecha_valida => p_s_fecha) THEN RAISE e_fecha_invalida;
    END IF;

    v_d_fecha := FN_CNFG_NUM_RET_DATE(p_n_fecha => TO_DATE(p_s_fecha, 'YYYYMMDD'));

    IF p_s_detalle = 'S' THEN

    SELECT
        COUNT(CNFGS_DT_SALDO.NUM_OPE) into v_n_contador
    FROM
        CNFGS_DT_SALDO
        JOIN CNFGS_DT_OPRCN ON CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
    WHERE
        CNFGS_DT_SALDO.IMP_SDO_CPL != v_nro_0
        AND CNFGS_DT_SALDO.NUM_IDE_REG = v_d_fecha
        AND CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
        AND CNFGS_DT_SALDO.NUM_IDE_REG = CNFGS_DT_OPRCN.NUM_IDE_REG;

    IF v_n_contador = 0 THEN RAISE no_data_found;
    END IF;

    OPEN p_c_datos FOR
    SELECT
        control,
        SDO_NRO_OPRCN_NUM,
        SDO_NRO_OPRCN_DV,
        SDO_COD_CENTA_CNTBLE,
        SDOFCH_SALDO_CNTBLE,
        SDO_MNT_SALDO_CNTBLE,
        SDO_MNT_SALDO_MONDA_ORIGN,
        SDO_TPO_CENTA,
        SDO_MRC_INT,
        SDO_MRC_MONDA,
        SDO_MRC_RJTB,
        SDO_FILLER,
        SDO_SUC_CTBLE
    FROM
        (
            SELECT
                1 AS control,
                v_nro_0081 || FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.NUM_OPE,
                    P_N_LENGTH => 10,
                    P_S_CHAR => v_nro_0
                ) AS SDO_NRO_OPRCN_NUM,
                v_nro_0 AS SDO_NRO_OPRCN_DV,
                FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.NUM_CCB_CPL,
                    P_N_LENGTH => 10,
                    P_S_CHAR => v_nro_0
                ) AS SDO_COD_CENTA_CNTBLE,
                FN_CNFG_LPAD(
                    P_S_CADENA => TO_CHAR(CNFGS_DT_SALDO.FEC_EST_CUO, 'YYYYMMDD'),
                    P_N_LENGTH => 8,
                    P_S_CHAR => v_nro_0
                ) AS SDOFCH_SALDO_CNTBLE,
                CASE
                    WHEN TO_NUMBER(CNFGS_DT_SALDO.IMP_SDO_CPL) > 0 THEN v_c_positivo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_CPL) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                    ELSE v_c_negativo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_CPL) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                END AS SDO_MNT_SALDO_CNTBLE,
                CASE
                    WHEN TO_NUMBER(CNFGS_DT_SALDO.IMP_SDO_CPL) > 0 THEN v_c_positivo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_CPL) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                    ELSE v_c_negativo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_CPL) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                END AS SDO_MNT_SALDO_MONDA_ORIGN,
                '01' AS SDO_TPO_CENTA,
                v_c_espacio AS SDO_MRC_INT,
                v_nro_0 AS SDO_MRC_MONDA,
                CASE
                    WHEN CNFGS_DT_OPRCN.COD_MON_OPE = 'CLP' THEN '00'
                    ELSE '08'
                END AS SDO_MRC_RJTB,
                FN_CNFG_LPAD(
                    P_S_CADENA => v_c_espacio,
                    P_N_LENGTH => 8,
                    P_S_CHAR => v_c_espacio
                ) AS SDO_FILLER,
                FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.COD_SUC_OPE,
                    P_N_LENGTH => 3,
                    P_S_CHAR => v_nro_0
                ) AS SDO_SUC_CTBLE
            FROM
                CNFGS_DT_SALDO
                JOIN CNFGS_DT_OPRCN ON CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
            WHERE
                CNFGS_DT_SALDO.IMP_SDO_CPL != v_nro_0
                AND CNFGS_DT_SALDO.NUM_IDE_REG = v_d_fecha
                AND CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
                AND CNFGS_DT_SALDO.NUM_IDE_REG = CNFGS_DT_OPRCN.NUM_IDE_REG
            UNION
            ALL
            SELECT
                1 AS control,
                v_nro_0081 || FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.NUM_OPE,
                    P_N_LENGTH => 10,
                    P_S_CHAR => v_nro_0
                ) AS SDO_NRO_OPRCN_NUM,
                v_nro_0 AS SDO_NRO_OPRCN_DV,
                FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.NUM_CCB_INT,
                    P_N_LENGTH => 10,
                    P_S_CHAR => v_nro_0
                ) AS SDO_COD_CENTA_CNTBLE,
                FN_CNFG_LPAD(
                    P_S_CADENA => TO_CHAR(CNFGS_DT_SALDO.FEC_EST_CUO, 'YYYYMMDD'),
                    P_N_LENGTH => 8,
                    P_S_CHAR => v_nro_0
                ) AS SDOFCH_SALDO_CNTBLE,
                CASE
                    WHEN TO_NUMBER(CNFGS_DT_SALDO.IMP_SDO_INT) > 0 THEN v_c_positivo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_INT) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                    ELSE v_c_negativo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_INT) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                END AS SDO_MNT_SALDO_CNTBLE,
                CASE
                    WHEN TO_NUMBER(CNFGS_DT_SALDO.IMP_SDO_INT) > 0 THEN v_c_positivo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_INT) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                    ELSE v_c_negativo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_INT) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                END AS SDO_MNT_SALDO_MONDA_ORIGN,
                '03' AS SDO_TPO_CENTA,
                v_c_espacio AS SDO_MRC_INT,
                v_nro_0 AS SDO_MRC_MONDA,
                CASE
                    WHEN CNFGS_DT_OPRCN.COD_MON_OPE = 'CLP' THEN '00'
                    ELSE '08'
                END AS SDO_MRC_RJTB,
                FN_CNFG_LPAD(
                    P_S_CADENA => v_c_espacio,
                    P_N_LENGTH => 8,
                    P_S_CHAR => v_c_espacio
                ) AS SDO_FILLER,
                FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.COD_SUC_OPE,
                    P_N_LENGTH => 3,
                    P_S_CHAR => v_nro_0
                ) AS SDO_SUC_CTBLE
            FROM
                CNFGS_DT_SALDO
                JOIN CNFGS_DT_OPRCN ON CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
            WHERE
                CNFGS_DT_SALDO.IMP_SDO_INT != v_nro_0
                AND CNFGS_DT_SALDO.NUM_IDE_REG = v_d_fecha
                AND CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
                AND CNFGS_DT_SALDO.NUM_IDE_REG = CNFGS_DT_OPRCN.NUM_IDE_REG
            UNION
            ALL
            SELECT
                1 AS control,
                v_nro_0081 || FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.NUM_OPE,
                    P_N_LENGTH => 10,
                    P_S_CHAR => v_nro_0
                ) AS SDO_NRO_OPRCN_NUM,
                v_nro_0 AS SDO_NRO_OPRCN_DV,
                FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.NUM_CCB_ISU,
                    P_N_LENGTH => 10,
                    P_S_CHAR => v_nro_0
                ) AS SDO_COD_CENTA_CNTBLE,
                FN_CNFG_LPAD(
                    P_S_CADENA => TO_CHAR(CNFGS_DT_SALDO.FEC_EST_CUO, 'YYYYMMDD'),
                    P_N_LENGTH => 8,
                    P_S_CHAR => v_nro_0
                ) AS SDOFCH_SALDO_CNTBLE,
                CASE
                    WHEN TO_NUMBER(CNFGS_DT_SALDO.IMP_SDO_ISU) > 0 THEN v_c_positivo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_ISU) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                    ELSE v_c_negativo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_ISU) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                END AS SDO_MNT_SALDO_CNTBLE,
                CASE
                    WHEN TO_NUMBER(CNFGS_DT_SALDO.IMP_SDO_ISU) > 0 THEN v_c_positivo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_ISU) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                    ELSE v_c_negativo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_ISU) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                END AS SDO_MNT_SALDO_MONDA_ORIGN,
                '  ' AS SDO_TPO_CENTA,
                v_c_espacio AS SDO_MRC_INT,
                v_nro_0 AS SDO_MRC_MONDA,
                CASE
                    WHEN CNFGS_DT_OPRCN.COD_MON_OPE = 'CLP' THEN '00'
                    ELSE '08'
                END AS SDO_MRC_RJTB,
                FN_CNFG_LPAD(
                    P_S_CADENA => v_c_espacio,
                    P_N_LENGTH => 8,
                    P_S_CHAR => v_c_espacio
                ) AS SDO_FILLER,
                FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.COD_SUC_OPE,
                    P_N_LENGTH => 3,
                    P_S_CHAR => v_nro_0
                ) AS SDO_SUC_CTBLE
            FROM
                CNFGS_DT_SALDO
                JOIN CNFGS_DT_OPRCN ON CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
            WHERE
                CNFGS_DT_SALDO.IMP_SDO_ISU != v_nro_0
                AND CNFGS_DT_SALDO.NUM_IDE_REG = v_d_fecha
                AND CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
                AND CNFGS_DT_SALDO.NUM_IDE_REG = CNFGS_DT_OPRCN.NUM_IDE_REG
            UNION
            ALL
            SELECT
                1 AS control,
                v_nro_0081 || FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.NUM_OPE,
                    P_N_LENGTH => 10,
                    P_S_CHAR => v_nro_0
                ) AS SDO_NRO_OPRCN_NUM,
                v_nro_0 AS SDO_NRO_OPRCN_DV,
                FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.NUM_CCB_REJ,
                    P_N_LENGTH => 10,
                    P_S_CHAR => v_nro_0
                ) AS SDO_COD_CENTA_CNTBLE,
                FN_CNFG_LPAD(
                    P_S_CADENA => TO_CHAR(CNFGS_DT_SALDO.FEC_EST_CUO, 'YYYYMMDD'),
                    P_N_LENGTH => 8,
                    P_S_CHAR => v_nro_0
                ) AS SDOFCH_SALDO_CNTBLE,
                CASE
                    WHEN TO_NUMBER(CNFGS_DT_SALDO.IMP_SDO_REJ) > 0 THEN v_c_positivo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_REJ) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                    ELSE v_c_negativo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_REJ) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                END AS SDO_MNT_SALDO_CNTBLE,
                CASE
                    WHEN TO_NUMBER(CNFGS_DT_SALDO.IMP_SDO_REJ) > 0 THEN v_c_positivo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_REJ) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                    ELSE v_c_negativo || FN_CNFG_LPAD(
                        P_S_CADENA => ABS(CNFGS_DT_SALDO.IMP_SDO_REJ) * 10000,
                        P_N_LENGTH => 16,
                        P_S_CHAR => v_nro_0
                    )
                END AS SDO_MNT_SALDO_MONDA_ORIGN,
                '04' AS SDO_TPO_CENTA,
                v_c_espacio AS SDO_MRC_INT,
                v_nro_0 AS SDO_MRC_MONDA,
                CASE
                    WHEN CNFGS_DT_OPRCN.COD_MON_OPE = 'CLP' THEN '00'
                    ELSE '08'
                END AS SDO_MRC_RJTB,
                FN_CNFG_LPAD(
                    P_S_CADENA => v_c_espacio,
                    P_N_LENGTH => 8,
                    P_S_CHAR => v_c_espacio
                ) AS SDO_FILLER,
                FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_SALDO.COD_SUC_OPE,
                    P_N_LENGTH => 3,
                    P_S_CHAR => v_nro_0
                ) AS SDO_SUC_CTBLE
            FROM
                CNFGS_DT_SALDO
                JOIN CNFGS_DT_OPRCN ON CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
            WHERE
                CNFGS_DT_SALDO.IMP_SDO_REJ != v_nro_0
                AND CNFGS_DT_SALDO.NUM_IDE_REG = v_d_fecha
                AND CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
                AND CNFGS_DT_SALDO.NUM_IDE_REG = CNFGS_DT_OPRCN.NUM_IDE_REG
        )
    ORDER BY
        SDO_NRO_OPRCN_NUM ASC,
        CASE
            WHEN SDO_TPO_CENTA = '01' THEN 1
            WHEN SDO_TPO_CENTA = '03' THEN 2
            WHEN SDO_TPO_CENTA = '  ' THEN 3
            WHEN SDO_TPO_CENTA = '04' THEN 4
            ELSE 5
        END;

    ELSIF p_s_detalle = 'F' THEN

    SELECT
        COUNT(CNFGS_DT_SALDO.NUM_OPE) into v_n_contador
    FROM
        CNFGS_DT_OPRCN,
        CNFGS_DT_SALDO
    WHERE
        CNFGS_DT_SALDO.NUM_IDE_REG = v_d_fecha
        AND CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
        AND CNFGS_DT_SALDO.NUM_IDE_REG = CNFGS_DT_OPRCN.NUM_IDE_REG;

    IF v_n_contador = 0 THEN RAISE no_data_found;
    END IF;

    OPEN p_c_datos FOR
    SELECT
        1 AS control,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_PRM_VNO, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS FLU_FCH_FLUJO,
        FN_CNFG_LPAD(
            P_S_CADENA => POR_TSB_OPE * 10000,
            P_N_LENGTH => 7,
            P_S_CHAR => v_nro_0
        ) AS FLU_VLR_TASA_PRMDO_PNDRO,
        FN_CNFG_LPAD(
            P_S_CADENA => num_pzo_pmd_ope,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS FLU_PLAZO_PRMDO_PND,
        v_c_positivo || FN_CNFG_LPAD(
            P_S_CADENA => imp_cpl_mor * imp_prd_cuo * 10000,
            P_N_LENGTH => 16,
            P_S_CHAR => v_nro_0
        ) AS FLU_MNT_CPTAL,
        v_c_positivo || FN_CNFG_LPAD(
            P_S_CADENA => (imp_org_ope * 10000),
            P_N_LENGTH => 16,
            P_S_CHAR => v_nro_0
        ) AS FLU_MNT_CPTAL_MONDA_ORIGN,
        v_c_positivo || FN_CNFG_LPAD(
            P_S_CADENA => imp_int_mor * imp_prd_cuo * 10000,
            P_N_LENGTH => 16,
            P_S_CHAR => v_nro_0
        ) AS FLU_MNT_INTRS,
        v_c_positivo || FN_CNFG_LPAD(
            P_S_CADENA => (imp_int_mor * 10000),
            P_N_LENGTH => 16,
            P_S_CHAR => v_nro_0
        ) AS FLU_MNT_INTRS_MONDA_ORIGN,
        v_c_positivo || FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 16,
            P_S_CHAR => v_nro_0
        ) AS FLU_MNT_REJTE,
        v_c_positivo || FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 16,
            P_S_CHAR => v_nro_0
        ) AS FLU_MNT_REJTE_MONDA_ORIGN,
        v_c_positivo || FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 16,
            P_S_CHAR => v_nro_0
        ) AS FLU_MNT_CMSON,
        v_c_positivo || FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 16,
            P_S_CHAR => v_nro_0
        ) AS FLU_MNT_CMSON_MONDA_ORIGN,
        v_nro_0081 || FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_OPE,
            P_N_LENGTH => 10,
            P_S_CHAR => v_nro_0
        ) AS FLU_NRO_OPRCN_NUM,
        v_nro_0 AS FLU_NRO_OPRCN_DV,
        FN_CNFG_LPAD(
            P_S_CADENA => v_c_espacio,
            P_N_LENGTH => 7,
            P_S_CHAR => v_c_espacio
        ) AS FLU_TPO_INFRM,
        '00' AS FLU_MRC_INT,
        CASE
            WHEN cod_est_cuo = 4
            OR cod_est_cuo = 5 THEN '0'
            ELSE '1'
        END AS FLU_TPO_FLJ,
        FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 6,
            P_S_CHAR => v_nro_0
        ) AS FILLER
    FROM
        CNFGS_DT_OPRCN,
        CNFGS_DT_SALDO
    WHERE
        CNFGS_DT_SALDO.NUM_IDE_REG = v_d_fecha
        AND CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
        AND CNFGS_DT_SALDO.NUM_IDE_REG = CNFGS_DT_OPRCN.NUM_IDE_REG
    ORDER BY
        control DESC;

    ELSIF p_s_detalle = 'C' THEN

    SELECT
        COUNT(CNFGS_DT_OPRCN.NUM_OPE) into v_n_contador
    FROM
        CNFGS_DT_OPRCN
    WHERE
        NUM_IDE_REG = v_d_fecha;

    IF v_n_contador = 0 THEN RAISE no_data_found;
    END IF;

    OPEN p_c_datos FOR
    SELECT
        1 AS control,
        v_nro_0081 || FN_CNFG_LPAD(
            P_S_CADENA => NUM_OPE,
            P_N_LENGTH => 10,
            P_S_CHAR => v_nro_0
        ) AS CPR_NRO_OPRCN_NUM,
        v_nro_0 AS CPR_NRO_OPRCN_DV,
        FN_CNFG_LPAD(
            P_S_CADENA => cod_pto_ope,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) || FN_CNFG_LPAD(
            P_S_CADENA => cod_spo_ope,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS CPR_COD_PRDTO,
        FN_CNFG_RUT(
            CNFGS_DT_OPRCN.NUM_RUT_CLT
        ) AS CPR_NRO_PRSNA,
        FN_CNFG_RUT_DV(
            CNFGS_DT_OPRCN.NUM_RUT_CLT
        ) AS CPR_DNRO_PRSNA,
        FN_CNFG_LPAD(
            P_S_CADENA => '97036000K',
            P_N_LENGTH => 10,
            P_S_CHAR => v_nro_0
        ) AS CPR_NRO_EMPSA,
        '1135' AS CPR_COD_CENTA_SBIF,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(fec_cse_ope, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS CPR_FCH_CURSE_OPRCN,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(fec_trm_ope, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS CPR_FCH_VNCTO_OPRCN,
        FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS CPR_COD_MONDA,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(fec_trm_ope, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS CPR_FCH_PRXMO_VNCTO_OPRCN,
        CASE
            WHEN cod_vrc_tsa = 0 THEN 'F'
            WHEN cod_vrc_tsa = 1 THEN 'V'
            WHEN cod_vrc_tsa = 2 THEN 'L'
        END AS CPR_MRC_TASA_FIJA_VARBL,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(fec_cse_ope, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS CPR_FCH_CAMBO_TASA_INTRS,
        FN_CNFG_LPAD(
            P_S_CADENA => SUBSTR(flg_clo_int, 1, 2),
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS CPR_MRC_TIPO_APLCN_INTRS,
        FN_CNFG_LPAD(
            P_S_CADENA => por_tsb_ope * 10000,
            P_N_LENGTH => 7,
            P_S_CHAR => v_nro_0
        ) AS CPR_VLR_TASA_INTRS,
        '360' AS CPR_COD_BASE_TASA_INTRS,
        CASE
            WHEN cod_mon_ope = 'CLP' THEN '00'
            ELSE '08'
        END AS CPR_COD_RJTBD,
        FN_CNFG_LPAD(
            P_S_CADENA => num_pzo_pmd_ope,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS CPR_CAN_DIAS_PLAZO_INICL,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR((TO_DATE(v_d_fecha, 'YYYYMMDD') - fec_trm_ope)),
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS CPR_CAN_DIAS_PLAZO_RESDL,
        FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS CPR_FRC_VNCTO,
        FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS CPR_FRC_REPRC,
        '09' AS CPR_COD_FORMA_AMTZN,
        FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS CPR_COD_TASA_INTRS,
        FN_CNFG_LPAD(
            P_S_CADENA => cod_suc_ope,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS CPR_COD_SUCSL,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(SYSDATE, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS CPR_FCH_ACTLZ_DATOS,
        'CFG' AS CPR_COD_SISTM,
        FN_CNFG_LPAD(
            P_S_CADENA => v_c_espacio,
            P_N_LENGTH => 4,
            P_S_CHAR => v_c_espacio
        ) AS CPR_TPO_FLOTADOR,
        'N' AS CPR_MRC_DVG_SUSP,
        CASE
            WHEN cod_mon_ope = 'CLP' THEN '999'
            WHEN cod_mon_ope = 'USD' THEN '013'
        END AS CPR_COD_MON_LIQ,
        '+0000000' AS CPR_SPREAD,
        'L' AS CPR_MTDO_DVGO,
        FN_CNFG_LPAD(
            P_S_CADENA => v_c_espacio,
            P_N_LENGTH => 2,
            P_S_CHAR => v_c_espacio
        ) AS CPR_MRC_ORGANIZ,
        FN_CNFG_LPAD(
            P_S_CADENA => v_c_espacio,
            P_N_LENGTH => 6,
            P_S_CHAR => v_c_espacio
        ) AS CPR_MRC_MICROCOB,
        FN_CNFG_LPAD(
            P_S_CADENA => v_c_espacio,
            P_N_LENGTH => 15,
            P_S_CHAR => v_c_espacio
        ) AS CPR_RESTO,
        'A' AS CPR_TPO_REG,
        v_c_espacio AS CPR_TPO_CARTR,
        FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS CPR_TPO_INM,
        FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 2,
            P_S_CHAR => v_nro_0
        ) AS CPR_MCA_ESTRATEGIA,
        v_c_espacio AS CPR_MRC_INT,
        v_nro_0 AS CPR_FLG_SENSIBILIDAD,
        v_nro_0 AS CPR_FLG_TPO_INV,
        v_nro_0 AS CPR_MCA_ENTREGA,
        FN_CNFG_LPAD(
            P_S_CADENA => v_nro_0,
            P_N_LENGTH => 7,
            P_S_CHAR => v_nro_0
        ) AS CPR_VLR_TASA_TRANSF
    FROM
        CNFGS_DT_OPRCN
    WHERE
        NUM_IDE_REG = v_d_fecha
    ORDER BY
        control DESC;

    ELSE RAISE e_parametro_invalido;

    END IF;

    v_s_mensaje := 'OK';
    v_n_retorno := v_nro_0;
    p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);

EXCEPTION
    WHEN e_parametro_invalido THEN
        v_n_retorno := v_nro_1;
        v_s_mensaje := 'El parametro no es valido';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN e_fecha_nula THEN
        v_n_retorno := v_nro_1;
        v_s_mensaje := 'Error fecha vacia o nula';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN e_fecha_invalida THEN
        v_n_retorno := v_nro_1;
        v_s_mensaje := 'Error fecha formato incorrecto';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN no_data_found THEN
        v_n_retorno := v_nro_1;
        v_s_mensaje := 'No existen datos';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN OTHERS THEN
        v_n_retorno := v_nro_1;
        v_s_mensaje := 'SP_CNFG_INTFZ_GAP - '
                       || sqlcode
                       || ' - '
                       || sqlerrm
                       || ' - '
                       || dbms_utility.format_error_backtrace;

        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);

END SP_CNFG_INTFZ_GAP;
