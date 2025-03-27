create or replace PROCEDURE "SP_CNFG_INTFZ_ANGLR" (
    P_S_DETALLE IN VARCHAR2,
    P_S_FECHA IN VARCHAR2,
    P_C_DATOS OUT SYS_REFCURSOR,
    P_C_SALIDA OUT SYS_REFCURSOR
) AS
    /*************************************************************************************************
     PROCEDIMIENTO: SP_CNFG_INTFZ_ANGLR
     HU           : J00102-5941
     OBJETIVO:      SERVICIO QUE TIENE COMO PROPOSITO CONSULTAR TABLAS TEMPORALES
     SISTEMA:       CNFCG
     BASE DE DATOS: CONFIG_GLOBAL_DBO
     TABLAS USADAS: CNFGS_DT_SALDO
     CNFGS_DT_OPRCN
     FECHA:         16-10-2024
     AUTOR:         JONATAN SOTO - CELULA INGENIO
     INPUT:         P_S_DETALLE
     P_S_FECHA
     OUTPUT:        P_C_DATOS
     P_C_SALIDA
     OBSERVACIONES:
     REVISIONES:
     VER        DATE        AUTHOR                DESCRIPTION
     ---------  ----------  -------------------   ------------------------------------
     M0         17-10-2024  JONATAN SOTO     VERSION INICIAL
     --************************************************************************************************/
    --P_C_CURSOR             SYS_REFCURSOR;
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
    v_c_espacio CONSTANT CHAR(1) := ' ';

BEGIN 

    IF p_s_fecha IS NULL OR TRIM(p_s_fecha) = '' THEN RAISE e_fecha_nula;
    END IF;

    IF NOT FN_CNFG_NUM_IDF_REG(p_s_fecha_valida => p_s_fecha) THEN RAISE e_fecha_invalida;
    END IF;

    v_d_fecha := FN_CNFG_NUM_RET_DATE(p_n_fecha => TO_DATE(p_s_fecha, 'YYYYMMDD'));

    IF P_S_DETALLE = 'D' THEN OPEN P_C_DATOS FOR
    SELECT
        1 CONTROL,
        FN_CNFG_RUT(P_S_RUT => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUC_NRT_PPAL1,
        FN_CNFG_RUT_DV(P_S_RUT => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUC_DRT_PPAL1,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_END,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ID_ENTIDAD,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_SUC_OPE,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ID_SUCURSAL,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_OPE,
            P_N_LENGTH => 12,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ID_NUMERO_OPERAC,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_PTO_OPE,
            P_N_LENGTH => 2,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ID_PRODUCTO_ALT,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_SPO_OPE,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ID_SUBPROD_ALT,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_SEQ,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ID_SECUENCIA,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_RTO,
            P_N_LENGTH => 6,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ID_RESTO,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_ITR_OPE,
            P_N_LENGTH => 20,
            P_S_CHAR => v_nro_0
        ) AS DEUD_NRO_INTERNO,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_PGR,
            P_N_LENGTH => 12,
            P_S_CHAR => v_nro_0
        ) AS DEUD_NRO_PAGARE,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_PTO_EXT,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_PRODUCTO_SBIF,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_SUC_CTB,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS DEUD_COD_SUC_CONTABLE,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_ATV_DTN,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ACT_DEST_OPERACION,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_TPO_CDT,
            P_N_LENGTH => 2,
            P_S_CHAR => v_nro_0
        ) AS DEUD_TIPO_CREDITO_SBIF,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_ECL_OPE,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS DEUD_OFICIAL_CLIENTE,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_ETA_OPE,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS DEUD_OFICIAL_OPE,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_EJV_OPE,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS DEUD_OFICIAL_VTA,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_CGO_AUT,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_CARGO_AUTOMATICO,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_CTA_CGO,
            P_N_LENGTH => 20,
            P_S_CHAR => v_nro_0
        ) AS DEUD_NRO_CTA_CARGO_AUTOMATICO,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_DJD_OPE,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_COBZA_JUDICIAL,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_CCB_OPE,
            P_N_LENGTH => 11,
            P_S_CHAR => v_nro_0
        ) AS DEUD_CUENTA_CONTABLE_ORIGINAL,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_SGD_OPE,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_SEG_DESGR,
        'N' AS DEUD_IND_SEG_INCEN,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_SGR_CES,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_SEG_CESAN,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_OTR_SGR,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_SEG_OTRO,
        FN_CNFG_LPAD(
            P_S_CADENA => DSC_SIS_ORG,
            P_N_LENGTH => 3,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_SISTEMA_ORIGEN,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_BCO_ORG,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_BANCO_ORIGEN_OPERACION,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_CSE_OPE, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_CURS,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_OTD_OPE, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_OTOR,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_RNV_OPE, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_RENOV,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_TRM_OPE, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_EXTI,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_PRM_VNO, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_1ER_VCTO,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_PXM_VNO_CPL, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_PROX_VCTO_CAP,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_PXM_VNO_INT, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_PROX_VCTO_INT,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_ISU_OPE, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_SUSP_DEVEN,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_INT_PGO, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_INT_PAGADOS,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_ULT_PAG, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_ULT_PAGO,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_TCV_OPE, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_TRAS_CVENC_1ERA,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_TRS_CAG, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_TRAS_CASTG_1ERA,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_ACR, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_ACELERACION,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_VNO_OGL, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FECHA_VCTO_ORIGINAL,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_ORG_OPE,
            p_n_enteros => 13,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_MTO_ORIG_CDTO_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_RNV_OPE,
            p_n_enteros => 13,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_MTO_RENO_CDTO_MO,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_CUA_PAG,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_CUADRO_PAGO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_CUO,
            p_n_enteros => 13,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_MTO_CUOTA_MO,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_CUO_PAT,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_NROCUO_PACTADAS,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_CUO_IPG,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_NROCUO_IMPAGAS,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_CUO_PAG,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_NROCUO_PAGADAS,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_FCC_CUO_CPL,
            P_N_LENGTH => 2,
            P_S_CHAR => v_nro_0
        ) AS DEUD_PERIOD_CUOTA_CAP,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_FCC_CUO_INT,
            P_N_LENGTH => 2,
            P_S_CHAR => v_nro_0
        ) AS DEUD_PERIOD_CUOTA_INT,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_PZO_PMD_OPE,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_PZO_PROM_POND,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_PZO_PMD_RDL,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_PZO_PROM_RESI,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_PPN_OPE,
            p_n_enteros => 13,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_MTO_PREPAGADO_MO,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_AMT_OPE,
            P_N_LENGTH => 3,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_METODO_AMORTIZAC,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_CLO_INT,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_TIP_CALCULO,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_VRC_TSA,
            P_N_LENGTH => 1,
            P_S_CHAR => v_nro_0
        ) AS DEUD_COD_VAR_TASA,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_ERS_TSA,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_EXP_TASA,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_TTS,
            P_N_LENGTH => 5,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_COD_TASA_BASE_BANCO,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_TTS_CMF,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_COD_TASA_BASE_SBIF,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_CBO_TSA, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FEC_ULT_CAMB_TASA,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_PXM_CBO_TSA, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FEC_PROX_CAMB_TASA,
        FN_CNFG_LPAD(
            P_S_CADENA => REPLACE(POR_TSB_OPE, ',' ,''),
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_VALOR_TASA_BASE,
        FN_CNFG_LPAD(
            P_S_CADENA => REPLACE(POR_TSS_OPE, ',' ,''),
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_SPREAD,
        FN_CNFG_LPAD(
            P_S_CADENA => REPLACE(POR_TSA_VGT,  ',' ,''),
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_TASA_VIGENTE,
        FN_CNFG_LPAD(
            P_S_CADENA => REPLACE(POR_TST_OPE, ',' ,''),
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_TASA_TRANSF,
        FN_CNFG_LPAD(
            P_S_CADENA => REPLACE(POR_TSA_EFT, ',' ,''),
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_TASA_EFECTIVA,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_MON_OPE,
            P_N_LENGTH => 3,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_COD_MDA_BANCO,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_MON_OPE_CMF,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_COD_MDA_SBIF,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_MON_CTB_CPL,
            P_N_LENGTH => 3,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_TIPMDA_CONTAB_CAP,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_MON_CTB_INT,
            P_N_LENGTH => 3,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_TIPMDA_CONTAB_INT,
        FN_CNFG_LPAD(
            P_S_CADENA => VAL_TPO_CBO_OPE,
            P_N_LENGTH => 11,
            P_S_CHAR => v_nro_0
        ) AS DEUD_TIPO_CAMBIO,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_OPE_RNE,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_CDTO_RENEGOCIADO,
        FN_CNFG_LPAD(
            P_S_CADENA => POR_DSB_RNE,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_PORC_DESEM_RNG,
        FN_CNFG_LPAD(
            P_S_CADENA => VAL_ATN_RNE,
            P_N_LENGTH => 17,
            P_S_CHAR => v_nro_0
        ) AS DEUD_MTO_ACTIVADO_RNG,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_CNV_ALD,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_COMEX_ALADI,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_CCR_OPE, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_FEC_APER_CARTA_CDTO,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_CDT_ADM,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_CRED_ADMINIST,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_CPC_FNR,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_COD_COMPOSICION_INV_FIN,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_BLQ_TJT,
            P_N_LENGTH => 2,
            P_S_CHAR => v_nro_0
        ) AS DEUD_BLQ_TARJETA,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_TJT_ADC,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_NRO_TARJ_ADICIONALES,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_DIP_LCD,
            p_n_enteros => 13,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_MTO_LINEA_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_DIP_LNA_SBG,
            p_n_enteros => 13,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_DIS_LINEA_MO,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_REG_CUO,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_NRO_REGISTROS_CUOTAS,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_REG_RLD,
            P_N_LENGTH => 3,
            P_S_CHAR => v_nro_0
        ) AS DEUD_NRO_REGISTROS_RELACIONES,
        FN_CNFG_LPAD(
            P_S_CADENA => POR_OPC_CMP,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_PORC_OPCION_COMPRA,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_BNS,
            p_n_enteros => 11,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_VALOR_DEL_BIEN_MN,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_CSR_OPE,
            P_N_LENGTH => 2,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_CLAS_COMERCIAL_LSG_FAC,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_RPB_OPE,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_RESPONS_OPER,
        FN_CNFG_RUT(P_S_RUT => NUM_RUT_RPB_OPE) DEUD_NRT_RESPONS_FAC,
        FN_CNFG_RUT_DV(P_S_RUT => NUM_RUT_RPB_OPE) DEUD_DRT_RESPONS_FAC,
        FN_CNFG_LPAD(
            P_S_CADENA => POR_AVL,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_PORC_AVAL_CORFO_FOGAPE,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_AFT_IVA,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_AFECTO_IVA,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_CDT_SRZ,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_CRED_SECURITIZ,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_EXD_LNA,
            p_n_enteros => 13,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_MTO_EXCESO_LINEA_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_LNA_DOS,
            p_n_enteros => 13,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_MTO_LINEA2_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_DIP_LNA_DOS,
            p_n_enteros => 13,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_DIS_LINEA2_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_DIP_LNA_DOS,
            p_n_enteros => 13,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_MTO_EXCESO_LINEA2_MO,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_SUC_SLT,
            P_N_LENGTH => 4,
            P_S_CHAR => v_nro_0
        ) AS DEUD_COD_SUC_SOLICITUD,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_SLT,
            P_N_LENGTH => 16,
            P_S_CHAR => v_nro_0
        ) AS DEUD_NRO_SOLICITUD,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_CDT_RFC,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_IND_CRED_REFINANCIADO,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_CAL_ATP, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ODS_FEC_CAN_ANT,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_CAL_ATP_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_CAN_ANT_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_CAL_ATP_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_CAN_ANT_MO,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_PZO_AMT,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ODS_PLZ_AMRT,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_PZO_AMT,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_ODS_COD_UNI_PLZ_AMRT,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_DIA_MRA,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ODS_NUM_DIA_DEMORA,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_CUO_INL,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_CUO_INI_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_AMT_PCP_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_AMRT_PRI_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_AMT_PCP_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_AMRT_PRI_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_FAL_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_SDO_FALL_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_FAL_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_SDO_FALL_MO,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_TPO_CZN,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_ODS_COD_COMPOS_INT,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_RVS_TSA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_ULT_REV_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_CVE_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_SDO_VEN_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_CVE_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_SDO_VEN_MO,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_FLJ_CUO_IRG,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_ODS_FLAG_IND_FLJS_IRREG,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_CBO_CDC, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ODS_FEC_CAMB_COND,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_IPG_VGT, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ODS_FEC_PRIMER_IMP_VIG,
        FN_CNFG_LPAD(
            P_S_CADENA => POR_TSM,
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ODS_TAS_INT_MAX,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_TPO_TSA_EXS,
            P_N_LENGTH => 3,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_ODS_COD_BASE_TAS_INT_EXC,
        FN_CNFG_LPAD(
            P_S_CADENA => POR_TSA_EXS,
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ODS_TAS_INT_EXC,
        FN_CNFG_LPAD(
            P_S_CADENA => TO_CHAR(FEC_DBT, 'YYYYMMDD'),
            P_N_LENGTH => 8,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ODS_FEC_DESCUBIERTO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_LMT_LCD,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_LIM_CREDITO_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_SAL_CAG_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_SAL_CAS_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_SAL_CAG_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_SAL_CAS_MO,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_TPO_ORG_FND,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_ODS_TIP_ORIGEN_FONDO_ACT,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_TPO_FND,
            P_N_LENGTH => 3,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_ODS_COD_FONDO_AJENO_ACT,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_INT_DFD_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_INT_DIFER_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_INT_DFD_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_INT_DIFER_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_INT_DFD_PMD_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_INT_MED_DIFER_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_INT_DFD_PMD_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_INT_MED_DIFER_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_INT_CBR_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_INT_COB_PAG_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_INT_CBR_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_INT_COB_PAG_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_INT_EXS_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_INT_EXC_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_INT_EXS_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_INT_EXC_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_PRC_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_PRECIO_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_PRC_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_PRECIO_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_EXS_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_EXC_LIM_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_EXS_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_EXC_LIM_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SPM_EXS_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_MED_EXC_LIM_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_PMD_NDS_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_MED_NDISP_LC_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_PMD_NDS_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_MED_NDISP_LC_MO,
        FN_CNFG_LPAD(
            P_S_CADENA => COD_STC_CTB,
            P_N_LENGTH => 3,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_ODS_COD_SIT_CONTABLE,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_MNJ_INT,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_ODS_IND_INT_ML,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_FRA_BLC,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_ODS_IND_FUERA_BLCE,
        FN_CNFG_LPAD(
            P_S_CADENA => NUM_RRC,
            P_N_LENGTH => 5,
            P_S_CHAR => v_nro_0
        ) AS DEUD_ODS_NUM_REPRECIOS,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_TC_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_PAGO_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_TC_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_PAGO_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_DSS_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_DISP_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_DSS_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_DISP_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_PMD_PND_AMT_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_MED_PEND_AMRT_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_PMD_RRC_MOR,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_SDO_MED_ANT_REP_MO,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_TRU_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_MORA1_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_TMD_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_MORA2_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_TR3_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_MORA3_ML,
        FN_CNFG_MON_FTO(
            p_n_monto => IMP_SDO_TR4_MNA,
            p_n_enteros => 16,
            p_n_decimales => 4,
            p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_MORA4_ML,
        FN_CNFG_MON_FTO(
                    p_n_monto => IMP_SDO_TR5_MNA,
                    p_n_enteros => 16,
                    p_n_decimales => 4,
                    p_s_tipo_moneda => COD_MON_OPE_CMF
        ) AS DEUD_ODS_IMP_MORA5_ML,
        FN_CNFG_LPAD(
            P_S_CADENA => FLG_ACV_CGT,
            P_N_LENGTH => 1,
            P_S_CHAR => v_c_espacio
        ) AS DEUD_ODS_FLAG_ACT_CNTG
    FROM
        CNFGS_DT_OPRCN
    WHERE
        NUM_IDE_REG = V_D_FECHA
    ORDER BY
        CONTROL DESC;

    ELSIF P_S_DETALLE = 'S' THEN OPEN P_C_DATOS FOR
        SELECT
        1 AS CONTROL,
        FN_CNFG_RUT(P_S_RUT => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUC_NRT_PPAL1,
        FN_CNFG_RUT_DV(P_S_RUT => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUC_DRT_PPAL1,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_END,
            P_N_LENGTH => 4,
            P_S_CHAR => 0
        ) AS DEUC_ID_ENTIDAD,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_OPRCN.COD_MON_OPE,
            P_N_LENGTH => 3,
            P_S_CHAR => ' '
        ) AS DEUD_ODS_COD_DIVISA,
        DECODE(CNFGS_DT_OPRCN.COD_MON_OPE, 'CLP', 0, 3) AS DEUD_ODS_TIP_DIVISA,
        FN_CNFG_RPAD(
            P_S_CADENA => CNFGS_DT_SALDO.COD_SUC_OPE,
            P_N_LENGTH => 4,
            P_S_CHAR => 0
        ) AS DEUC_ID_SUCURSAL,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_OPE,
            P_N_LENGTH => 12,
            P_S_CHAR => 0
        ) AS DEUC_ID_NUMERO_OPERAC,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.COD_PTO_OPE,
            P_N_LENGTH => 2,
            P_S_CHAR => 0
        ) AS DEUC_ID_PRODUCTO_ALT,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.COD_SPO_OPE,
            P_N_LENGTH => 4,
            P_S_CHAR => 0
        ) AS DEUC_ID_SUBPROD_ALT,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_SEQ,
            P_N_LENGTH => 3,
            P_S_CHAR => 0
        ) AS DEUC_ID_SECUENCIA,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_RTO,
            P_N_LENGTH => 6,
            P_S_CHAR => 0
        ) AS DEUC_ID_RESTO,
        'COLOC' AS DEUC_ID_CONCEPTO,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.COD_EST_CUO,
            P_N_LENGTH => 1,
            P_S_CHAR => 0
        ) AS DEUC_ESTADO_SALDO,
        FN_CNFG_LPAD(
            P_S_CADENA => 'K',
            P_N_LENGTH => 1,
            P_S_CHAR => ' '
        ) AS DEUC_CLASE_SALDO,
        FN_CNFG_RPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_CCB_CPL,
            P_N_LENGTH => 15,
            P_S_CHAR => ' '
        ) AS DEUC_CTA_CTBLE,
        FN_CNFG_RDR_FMT(
            P_N_VALOR => CNFGS_DT_SALDO.IMP_CPL_MOR,
            P_C_PREFIJO => 'K'
        ) AS DEUC_SALDO_MO,
        FN_CNFG_RDR_FMT(
            P_N_VALOR =>(
                CNFGS_DT_SALDO.IMP_CPL_MOR * CNFGS_DT_SALDO.IMP_PRD_CUO
            ),
            P_C_PREFIJO => 'K'
        ) AS DEUC_SALDO_ML,
        FN_CNFG_RDR_FMT(P_N_VALOR => 0, P_C_PREFIJO => 'K') AS DEUC_SALDO_MEDIO_MO,
        FN_CNFG_RDR_FMT(P_N_VALOR => 0, P_C_PREFIJO => 'K') AS DEUC_SALDO_MEDIO_ML,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_OPRCN.COD_SUC_SLT,
            P_N_LENGTH => 4,
            P_S_CHAR => 0
        ) AS DEUC_CENTRO_DESTINO
    FROM
        CNFGS_DT_SALDO,
        CNFGS_DT_OPRCN
    WHERE
        CNFGS_DT_SALDO.NUM_IDE_REG = V_D_FECHA
            AND CNFGS_DT_SALDO.NUM_IDE_REG = CNFGS_DT_OPRCN.NUM_IDE_REG
            AND CNFGS_DT_SALDO.NUM_RUT_CLT = CNFGS_DT_OPRCN.NUM_RUT_CLT
            AND CNFGS_DT_SALDO.NUM_END = CNFGS_DT_OPRCN.NUM_END
            AND CNFGS_DT_SALDO.COD_SUC_OPE = CNFGS_DT_OPRCN.COD_SUC_OPE
            AND CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE
    UNION
    SELECT
        1 AS CONTROL,
        FN_CNFG_RUT(P_S_RUT => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUC_NRT_PPAL1,
        FN_CNFG_RUT_DV(P_S_RUT => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUC_DRT_PPAL1,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_END,
            P_N_LENGTH => 4,
            P_S_CHAR => 0
        ) AS DEUC_ID_ENTIDAD,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_OPRCN.COD_MON_OPE,
            P_N_LENGTH => 3,
            P_S_CHAR => ' '
        ) AS DEUD_ODS_COD_DIVISA,
        DECODE(CNFGS_DT_OPRCN.COD_MON_OPE, 'CLP', 0, 3) AS DEUD_ODS_TIP_DIVISA,
        FN_CNFG_RPAD(
            P_S_CADENA => CNFGS_DT_SALDO.COD_SUC_OPE,
            P_N_LENGTH => 4,
            P_S_CHAR => 0
        ) AS DEUC_ID_SUCURSAL,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_OPE,
            P_N_LENGTH => 12,
            P_S_CHAR => 0
        ) AS DEUC_ID_NUMERO_OPERAC,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.COD_PTO_OPE,
            P_N_LENGTH => 2,
            P_S_CHAR => 0
        ) AS DEUC_ID_PRODUCTO_ALT,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.COD_SPO_OPE,
            P_N_LENGTH => 4,
            P_S_CHAR => 0
        ) AS DEUC_ID_SUBPROD_ALT,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_SEQ,
            P_N_LENGTH => 3,
            P_S_CHAR => 0
        ) AS DEUC_ID_SECUENCIA,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_RTO,
            P_N_LENGTH => 6,
            P_S_CHAR => 0
        ) AS DEUC_ID_RESTO,
        'DXCOB' AS DEUC_ID_CONCEPTO,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_SALDO.COD_EST_CUO,
            P_N_LENGTH => 1,
            P_S_CHAR => 0
        ) AS DEUC_ESTADO_SALDO,
        FN_CNFG_LPAD(
            P_S_CADENA => 'I',
            P_N_LENGTH => 1,
            P_S_CHAR => ' '
        ) AS DEUC_CLASE_SALDO,
        FN_CNFG_RPAD(
            P_S_CADENA => CNFGS_DT_SALDO.NUM_CCB_CPL,
            P_N_LENGTH => 15,
            P_S_CHAR => ' '
        ) AS DEUC_CTA_CTBLE,
        FN_CNFG_RDR_FMT(
            P_N_VALOR => CNFGS_DT_SALDO.IMP_SDO_REJ,
            P_C_PREFIJO => 'I'
        ) AS DEUC_SALDO_MO,
        FN_CNFG_RDR_FMT(
            P_N_VALOR => (
                CNFGS_DT_SALDO.IMP_SDO_REJ * CNFGS_DT_SALDO.IMP_PRD_CUO
            ),
            P_C_PREFIJO => 'I'
        ) AS DEUC_SALDO_ML,
        FN_CNFG_RDR_FMT(P_N_VALOR => 0, P_C_PREFIJO => 'I') AS DEUC_SALDO_MEDIO_MO,
        FN_CNFG_RDR_FMT(P_N_VALOR => 0, P_C_PREFIJO => 'I') AS DEUC_SALDO_MEDIO_ML,
        FN_CNFG_LPAD(
            P_S_CADENA => CNFGS_DT_OPRCN.COD_SUC_SLT,
            P_N_LENGTH => 4,
            P_S_CHAR => 0
        ) AS DEUC_CENTRO_DESTINO
    FROM
        CNFGS_DT_SALDO,
        CNFGS_DT_OPRCN
    WHERE
        CNFGS_DT_SALDO.NUM_IDE_REG = V_D_FECHA
            AND CNFGS_DT_SALDO.NUM_IDE_REG = CNFGS_DT_OPRCN.NUM_IDE_REG
            AND CNFGS_DT_SALDO.NUM_RUT_CLT = CNFGS_DT_OPRCN.NUM_RUT_CLT
            AND CNFGS_DT_SALDO.NUM_END = CNFGS_DT_OPRCN.NUM_END
            AND CNFGS_DT_SALDO.COD_SUC_OPE = CNFGS_DT_OPRCN.COD_SUC_OPE
            AND CNFGS_DT_SALDO.NUM_OPE = CNFGS_DT_OPRCN.NUM_OPE;

    ELSE RAISE e_parametro_invalido;
    END IF;

    v_s_mensaje := 'OK';
    v_n_retorno := v_nro_0;
    p_c_salida := FN_CNFG_RET_MENSAJE(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);

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
        v_s_mensaje := 'SP_CNFG_INTFZ_BCPRS - '
                       || sqlcode
                       || ' - '
                       || sqlerrm
                       || ' - '
                       || dbms_utility.format_error_backtrace;

        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
END SP_CNFG_INTFZ_ANGLR;