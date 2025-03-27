create or replace PROCEDURE            "SP_CNFG_INTFZ_DEUDR" (
    p_s_fecha  IN VARCHAR2,
    p_c_datos  OUT SYS_REFCURSOR,
    p_c_salida OUT SYS_REFCURSOR
) AS
    /*************************************************************************************************
     Procedimiento: SP_CNFG_INTFZ_DEUDR
     HU           : J00102-5937
     Objetivo:      Servicio que tiene como propósito generar una interface txt para Deudores

     Sistema:       CNFCG
     Base de Datos: CONFIG_GLOBAL_DBO
     Tablas Usadas:
     Fecha:         29-10-2024
     Autor:         Mauricio González - Celula Ingenio
     Input:
     p_s_fecha,

     Output:
     p_c_datos
     p_c_salida
     Observaciones:
     REVISIONES:
     Ver        Date        Author                Description
     ---------  ----------  -------------------   ------------------------------------
     m0         29-10-2024  Mauricio González     Version inicial
     --************************************************************************************************/
    ----------------------------------
    --Variables
    ----------------------------------
    v_d_fecha    NUMBER;
    v_n_retorno  NUMBER;
    v_s_mensaje  VARCHAR2(1000);
    v_n_contador NUMBER;
    ----------------------------------
    --Excepciones
    ----------------------------------
    e_fecha_nula EXCEPTION;
    e_fecha_invalida EXCEPTION;
    ----------------------------------
    --Constantes
    ----------------------------------
    v_nro_0      CONSTANT NUMBER := 0;
    v_nro_1      CONSTANT NUMBER := 1;
    v_c_espacio  CONSTANT CHAR(1) := ' ';
BEGIN
    IF p_s_fecha IS NULL OR trim(p_s_fecha) = '' THEN
        RAISE e_fecha_nula;
    END IF;
    IF NOT fn_cnfg_num_idf_reg(p_s_fecha_valida => p_s_fecha) THEN
        RAISE e_fecha_invalida;
    END IF;
    v_d_fecha := fn_cnfg_num_ret_date(p_n_fecha => TO_DATE(p_s_fecha, 'YYYYMMDD'));
    SELECT
        COUNT(cnfgs_dt_oprcn.num_rut_clt)
    INTO v_n_contador
    FROM
        cnfgs_dt_oprcn cnfgs_dt_oprcn
    WHERE
        cnfgs_dt_oprcn.num_ide_reg = v_d_fecha;
    IF v_n_contador = v_nro_0 THEN
        RAISE no_data_found;
    END IF;
        OPEN p_c_datos FOR
        SELECT
            1 control,
            FN_CNFG_RUT(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUDNRTPPAL,
            FN_CNFG_RUT_DV(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUDDRTPPAL,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_END,
                P_N_LENGTH => 4,
                P_S_CHAR => v_nro_0
            ) DEUDIDENTIDAD,
            --contexto:entidad,pi:11;pf:14,NUMBER(4,0) [Entidad, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_SUC_OPE,
                P_N_LENGTH => 4,
                P_S_CHAR => v_nro_0
            ) DEUDIDSUCURSAL,
            --contexto:sucursal,pi:15;pf:18,NUMBER(4,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_OPE,
                P_N_LENGTH => 12,
                P_S_CHAR => v_nro_0
            ) DEUDIDNUMEROOPERAC,
            --contexto:número de operación,pi:19;pf:30,NUMBER(12,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_PTO_OPE,
                P_N_LENGTH => 2,
                P_S_CHAR => v_nro_0
            ) DEUDIDPRODUCTOALT,
            --contexto:código producto altamira,pi:31;pf:32,NUMBER(2,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_SPO_OPE,
                P_N_LENGTH => 4,
                P_S_CHAR => v_nro_0
            ) DEUDIDSUBPRODALT,
            --contexto:código subproducto altamira,pi:33;pf:36,NUMBER(4,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_SEQ,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDIDSECUENCIA,
            --contexto:secuencia (para tarj. crédito),pi:37;pf:39,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_RTO,
                P_N_LENGTH => 6,
                P_S_CHAR => v_nro_0
            ) DEUDIDRESTO,
            --contexto:cero,pi:40;pf:45,NUMBER(6,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_ITR_OPE,
                P_N_LENGTH => 20,
                P_S_CHAR => v_nro_0
            ) DEUDNROINTERNO,
            --contexto:número interno(id de contrato),pi:46;pf:65,NUMBER(20,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_PGR,
                P_N_LENGTH => 12,
                P_S_CHAR => v_nro_0
            ) DEUDNROPAGARE,
            --contexto:número pagaré,pi:66;pf:77,NUMBER(12,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_PTO_EXT,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDPRODUCTOSBIF,
            --contexto:código producto SBIF,pi:78;pf:80,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_SUC_CTB,
                P_N_LENGTH => 4,
                P_S_CHAR => v_nro_0
            ) DEUDCODSUCCONTABLE,
            --contexto:código sucursal contable,pi:81;pf:84,NUMBER(4,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_ATV_DTN,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDACTDESTOPERACION,
            --contexto:código act. destino operación,pi:85;pf:87,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_TPO_CDT,
                P_N_LENGTH => 2,
                P_S_CHAR => v_nro_0
            ) DEUDTIPOCREDITOSBIF,
            --contexto_tipo de crédito SBIF,pi:88;pf:89,NUMBER(2,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_ECL_OPE,
                P_N_LENGTH => 4,
                P_S_CHAR => v_nro_0
            ) DEUDOFICIALCLIENTE,
            --contexto:código ejec. principal cliente,pi:90;pf:93,NUMBER(4,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_ETA_OPE,
                P_N_LENGTH => 4,
                P_S_CHAR => v_nro_0
            ) DEUDOFICIALOPE,
            --contexto:código ejec. operación,pi:94;pf:97,NUMBER(4,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_EJV_OPE,
                P_N_LENGTH => 4,
                P_S_CHAR => v_nro_0
            ) DEUDOFICIALVTA,
            --contexto_código vendedor de la operación,pi:98;pf:101,NUMBER(4,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.FLG_CGO_AUT,
                P_N_LENGTH => 1,
                P_S_CHAR => v_c_espacio
            ) DEUDINDCARGOAUTOMATICO,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_CTA_CGO,
                P_N_LENGTH => 20,
                P_S_CHAR => v_nro_0
            ) DEUDNROCTACARGOAUTOMATIC,
            --contexto:cuenta con cargo automático,pi:103;pf:122,NUMBER(20,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.FLG_DJD_OPE,
                P_N_LENGTH => 1,
                P_S_CHAR => v_c_espacio
            ) DEUDINDCOBZAJUDICIAL,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_CCB_OPE,
                P_N_LENGTH => 11,
                P_S_CHAR => v_nro_0
            ) DEUDCUENTACONTABLEORIGINAL,
            --contexto:cuenta contable original de operación,pi:124;pf:134,NUMBER(11) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.FLG_SGD_OPE,
                P_N_LENGTH => 1,
                P_S_CHAR => v_c_espacio
            ) DEUDINDSEGDESGR,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.FLG_OTR_SGR,
                P_N_LENGTH => 1,
                P_S_CHAR => v_c_espacio
            ) DEUDINDSEGINCEN,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.FLG_SGR_CES,
                P_N_LENGTH => 1,
                P_S_CHAR => v_c_espacio
            ) DEUDINDSEGCESAN,
            FN_CNFG_LPAD(
                P_S_CADENA => v_c_espacio,
                P_N_LENGTH => 1,
                P_S_CHAR => v_c_espacio
            ) DEUDINDSEGOTRO,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.DSC_SIS_ORG,
                P_N_LENGTH => 3,
                P_S_CHAR => v_c_espacio
            ) DEUDSISTEMAORIGEN,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_BCO_ORG,
                P_N_LENGTH => 1,
                P_S_CHAR => v_nro_0
            ) DEUDBANCOORIGENOPERACION,
            --contexto:código origen banco,pi:142;pf:142,NUMBER(1,0) [Number, ceros por delante del mismo]
            FN_CNFG_FILLER(p_n_cantidad => 38) FILLER1,
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_CSE_OPE, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHACURS,
            --contexto:fecha curse (ingreso al sistema),pi:181;pf:188,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_OTD_OPE, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHAOTOR,
            --contexto:fecha de otorgamiento,pi:189;pf:196,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_RNV_OPE, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHARENOV,
            --contexto:fecha última renovación,pi:197;pf:204,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_TRM_OPE, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHAEXTI,
            --contexto:fecha extinsión o vencimiento,pi:205;pf:212,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_PRM_VNO, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHA1ERVCTO,
            --contexto:fecha primer vencimiento,pi:213;pf:220,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_PXM_VNO_CPL, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHAPROXVCTOCAP,
            --contexto:fecha próximo vcto. Capital,pi:221;pf:228,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_PXM_VNO_INT, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHAPROXVCTOINT,
            --contexto:fecha próximo vcto. Interés,pi:229;pf:236,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_ISU_OPE, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHASUSPDEVEN,
            --contexto:fecha suspensión devengamientos,pi:237;pf:244,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_INT_PGO, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHAINTPAGADOS,
            --contexto:fecha intereses pagados,pi:245;pf:252,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_ULT_PAG, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHAULTPAGO,
            --contexto:fecha último pago de deuda,pi:253;pf:260,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_TCV_OPE, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHATRASCVENC1ERA,
            --contexto:1era. fecha traspaso a cart. Vencida,pi:261;pf:268,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_TRS_CAG, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECHATRASCASTG1ERA,
            --contexto:1era. fecha traspaso a castigo,pi:269;pf:276,DATE [Date, ceros por delante del mismo]
            FN_CNFG_FILLER(p_n_cantidad => 32) FILLER2,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.IMP_ORG_OPE,
                    p_n_enteros => 13,
                    p_n_decimales => 4,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDMTOORIGCDTOMO,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.IMP_RNV_OPE,
                    p_n_enteros => 13,
                    p_n_decimales => 4,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDMTORENOCDTOMO,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_CUA_PAG,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDCUADROPAGO,
            --contexto:0: una cuota,pi:343;pf:345,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.IMP_CUO,
                    p_n_enteros => 13,
                    p_n_decimales => 4,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDMTOCUOTAMO,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_CUO_PAT,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDNUMCUOPACTADAS,
            --contexto:cantidad de cuotas pactadas,pi:363;pf:,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_CUO_IPG,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDNROCUOIMPAGAS,
            --contexto:cantidad de cuotas impagas,pi:366;pf:368,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_CUO_PAG,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDNTOCUOPAGADAS,
            --contexto:cantidad de cuotas pagadas,pi:369;pf:371,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_FCC_CUO_CPL,
                P_N_LENGTH => 2,
                P_S_CHAR => v_nro_0
            ) DEUDPERIODCUOTACAP,
            --contexto:periocidad de las cuotas (capital),pi:372;pf:373,NUMBER(2,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_FCC_CUO_INT,
                P_N_LENGTH => 2,
                P_S_CHAR => v_nro_0
            ) DEUDPERIODCUOTAINT,
            --contexto:periocidad de las cuotas (interés),pi:374;pf:375,NUMBER(2,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_PZO_PMD_OPE,
                P_N_LENGTH => 5,
                P_S_CHAR => v_nro_0
            ) DEUDPZOPROMPOND,
            --contexto:plazo promedio ponderado original,pi:376;pf:380,NUMBER(5,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_PZO_PMD_RDL,
                P_N_LENGTH => 5,
                P_S_CHAR => v_nro_0
            ) DEUDPZOPROMRESI,
            --contexto:plazo promedio ponderado residual,pi:381;pf:405,NUMBER(5,0) [Number, ceros por delante del mismo]
            FN_CNFG_FILLER(p_n_cantidad => 20) FILLER3,
            FN_CNFG_LPAD(
                P_S_CADENA => 'A',
                P_N_LENGTH => 1,
                P_S_CHAR => v_c_espacio
            ) DEUDTIPCALCULO,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_VRC_TSA,
                P_N_LENGTH => 1,
                P_S_CHAR => v_nro_0
            ) DEUDCODVARTASA,
            --contexto:código variación tasa,pi:407;pf:,NUMBER(1,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_ERS_TSA,
                P_N_LENGTH => 1,
                P_S_CHAR => v_c_espacio
            ) DEUDEXPTASA,
            FN_CNFG_LPAD(
                P_S_CADENA => 'TAFI ',
                P_N_LENGTH => 5,
                P_S_CHAR => v_nro_0
            ) DEUDCODTASABASEBANCO,
            --contexto:código tasa base banco,pi:409;pf:413,NUMBER(5,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_TTS_CMF,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDCODTASABASESBIF,
            --contexto:código tasa base SBIF,pi:414;pf:416,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_CBO_TSA, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECULTCAMBTASA,
            --contexto:fecha último cambio tasa,pi:417;pf:424,DATE  [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_PXM_CBO_TSA, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECPROCAMTASA,
            --contexto:fecha próximo cambio de tasa,pi:425;pf:432,DATE  [Date, ceros por delante del mismo]
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.POR_TSB_OPE,
                    p_n_enteros => 2,
                    p_n_decimales => 3,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDVALORTASABASE,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.POR_TSS_OPE,
                    p_n_enteros => 2,
                    p_n_decimales => 3,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDSPREAD,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.POR_TSA_VGT,
                    p_n_enteros => 2,
                    p_n_decimales => 3,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDTASAVIGENTE,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.POR_TST_OPE,
                    p_n_enteros => 2,
                    p_n_decimales => 3,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDTASATRANSF,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.POR_TSA_EFT,
                    p_n_enteros => 2,
                    p_n_decimales => 3,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDTASAVIGENTED,
            FN_CNFG_FILLER(p_n_cantidad => 23) FILLER4,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_MON_OPE,
                P_N_LENGTH => 3,
                P_S_CHAR => v_c_espacio
            ) DEUDCODMDABANCO,
            FN_CNFG_LPAD(
                P_S_CADENA => '999',
                P_N_LENGTH => 3,
                P_S_CHAR => v_c_espacio
            ) DEUDCODMDASBIF,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_MON_CTB_CPL,
                P_N_LENGTH => 3,
                P_S_CHAR => v_c_espacio
            ) DEUDTIPMDACONTABCAP,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_MON_CTB_INT,
                P_N_LENGTH => 3,
                P_S_CHAR => v_c_espacio
            ) DEUDTIPMDACONTABINT,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.VAL_TPO_CBO_OPE,
                P_N_LENGTH => 11,
                P_S_CHAR => v_nro_0
            ) DEUDTIPOCAMBIO,
            --contexto:tipo cambio al otorgamiento,pi:493;pf:520,NUMBER(11,4)
            FN_CNFG_FILLER(p_n_cantidad => 17) FILLER5,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_OPE_RNE,
                P_N_LENGTH => 1,
                P_S_CHAR => v_c_espacio
            ) DEUDINDCDTORENEGOCIADO,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.POR_DSB_RNE,
                P_N_LENGTH => 5,
                P_S_CHAR => v_nro_0
            ) DEUDPROCDESEMRNG,
            --contexto:% desembolso créditos consumo reneg.,pi:522;pf:526,NUMBER(5,2) [Number, ceros por delante del mismo]
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.VAL_ATN_RNE,
                    p_n_enteros => 13,
                    p_n_decimales => 4,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDMTOACTIVADORNG,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.FLG_CNV_ALD,
                P_N_LENGTH => 1,
                P_S_CHAR => v_c_espacio
            ) DEUDINDCOMEXALADI,
            FN_CNFG_LPAD(
                P_S_CADENA => TO_CHAR(CNFGS_DT_OPRCN.FEC_CCR_OPE, 'YYYYMMDD'),
                P_N_LENGTH => 8,
                P_S_CHAR => v_nro_0
            ) DEUDFECAPERCARTACDTO,
            --contexto:fecha apertura carta crédito (Comex),pi:545;pf:552,DATE [Date, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.FLG_CDT_ADM,
                P_N_LENGTH => 1,
                P_S_CHAR => v_nro_0
            ) DEUDINDCREDADMINIST,
            FN_CNFG_LPAD(
                P_S_CADENA => TRIM(CNFGS_DT_OPRCN.COD_CPC_FNR),
                P_N_LENGTH => 5,
                P_S_CHAR => v_nro_0
            ) DEUDCODCOMPOSICIONINVFIN,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_BLQ_TJT,
                P_N_LENGTH => 2,
                P_S_CHAR => v_nro_0
            ) DEUDBLQTARJETA,
            --contexto:código bloqueo tarjeta,pi:559;pf:560,NUMBER(2,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_TJT_ADC,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDNROTARJADICIONALES,
            --contexto:número tarjetas adicionales,pi:561;pf:563,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.IMP_DIP_LCD,
                    p_n_enteros => 13,
                    p_n_decimales => 4,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDMTOLINEAMO,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_OPRCN.IMP_DIP_LNA_SBG,
                    p_n_enteros => 13,
                    p_n_decimales => 4,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUDDISLINEAMO,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_REG_CUO,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDNROREGISTROSCUOTAS,
            --contexto:cantidad reg. Interfaz de cuotas,pi:598;pf:600,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.NUM_REG_RLD,
                P_N_LENGTH => 3,
                P_S_CHAR => v_nro_0
            ) DEUDNROREGISTROSRELACIONES,
            --contexto:cantidad reg. Interfaz relaciones,pi:601;pf:603,NUMBER(3,0) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.POR_OPC_CMP,
                P_N_LENGTH => 5,
                P_S_CHAR => v_nro_0
            ) DEUDPORCCOMISION,
            --contexto:porcentaje de comisión,pi:604;pf:608,NUMBER(5,2) [Number, ceros por delante del mismo]
            fn_cnfg_transultnumstr(
                p_s_numero => FN_CNFG_LPAD(
                    P_S_CADENA => CNFGS_DT_OPRCN.IMP_BNS,
                    P_N_LENGTH => 15,
                    P_S_CHAR => v_nro_0
                )
            ) DEUDVALORBIEN,
            --contexto:valor bien asociado a la operación,pi:609;pf:623,NUMBER(15,2) [Number, ceros por delante del mismo]
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.COD_CSR_OPE,
                P_N_LENGTH => 2,
                P_S_CHAR => v_nro_0
            ) DEUDCODACTECO,
            FN_CNFG_LPAD(
                P_S_CADENA => CNFGS_DT_OPRCN.FLG_RPB_OPE,
                P_N_LENGTH => 1,
                P_S_CHAR => v_nro_0
            ) DEUDINDRESPONSOPER,
            FN_CNFG_RUT(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_RPB_OPE) DEUDNRTPRESPONSFAC,
            FN_CNFG_RUT_DV(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_RPB_OPE) DEUDDRTPRESPONSFACDV,
            FN_CNFG_FILLER(p_n_cantidad => 14) FILLER6
        FROM
            CNFGS_DT_OPRCN CNFGS_DT_OPRCN
        WHERE
            CNFGS_DT_OPRCN.NUM_IDE_REG = v_d_fecha
        ORDER BY
            control DESC;
        v_s_mensaje := 'OK';
        v_n_retorno := v_nro_0;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
EXCEPTION
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
        v_s_mensaje := 'SP_CNFG_INTFZ_DEUDR - '
                       || sqlcode
                       || ' - '
                       || sqlerrm
                       || ' - '
                       || dbms_utility.format_error_backtrace;

        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
END SP_CNFG_INTFZ_DEUDR;