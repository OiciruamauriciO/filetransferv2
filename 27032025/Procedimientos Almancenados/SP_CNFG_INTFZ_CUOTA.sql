create or replace PROCEDURE            "SP_CNFG_INTFZ_CUOTA" (
    p_s_fecha  IN VARCHAR2,
    p_c_datos  OUT SYS_REFCURSOR,
    p_c_salida OUT SYS_REFCURSOR
) AS
    /*************************************************************************************************
     Procedimiento: SP_CNFG_INTFZ_CUOTA_2
     HU           : J00102-5937
     Objetivo:      Servicio que tiene como propósito generar una interface txt para Cuotas

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
        cnfgs_dt_oprcn,
        cnfgs_dt_saldo
    WHERE
            cnfgs_dt_oprcn.num_rut_clt = cnfgs_dt_saldo.num_rut_clt
        AND cnfgs_dt_saldo.num_ide_reg = cnfgs_dt_oprcn.num_ide_reg
        AND cnfgs_dt_saldo.num_end = cnfgs_dt_oprcn.num_end
        AND cnfgs_dt_saldo.cod_suc_ope = cnfgs_dt_oprcn.cod_suc_ope
        AND cnfgs_dt_oprcn.num_ide_reg = v_d_fecha;
    IF v_n_contador = v_nro_0 THEN
        RAISE no_data_found;
    END IF;
        OPEN p_c_datos FOR
        SELECT
            1 CONTROL,
            FN_CNFG_RUT(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUC_NRT_PPAL1,
            FN_CNFG_RUT_DV(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUC_DRT_PPAL1,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.NUM_END,
                p_n_length => 4,
                p_s_char => v_nro_0
            ) DEUC_ID_ENTIDAD,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.COD_SUC_OPE,
                p_n_length => 4,
                p_s_char => v_nro_0
            ) DEUC_ID_SUCURSAL,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.NUM_OPE,
                p_n_length => 12,
                p_s_char => v_nro_0
            ) DEUC_ID_NUMERO_OPERAC,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.COD_PTO_OPE,
                p_n_length => 2,
                p_s_char => v_nro_0
            ) DEUC_ID_PRODUCTO_ALT,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.COD_SPO_OPE,
                p_n_length => 4,
                p_s_char => v_nro_0
            ) DEUC_ID_SUBPROD_ALT,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.NUM_SEQ,
                p_n_length => 3,
                p_s_char => v_nro_0
            ) DEUC_ID_SECUENCIA,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.NUM_RTO,
                p_n_length => 6,
                p_s_char => v_nro_0
            ) DEUC_ID_RESTO,
            FN_CNFG_LPAD(
                p_s_cadena => TO_CHAR(CNFGS_DT_SALDO.FEC_VNO_CUO, 'YYYYMMDD'),
                p_n_length => 8,
                p_s_char => v_nro_0
            ) DEUC_FEC_VCTO,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_SALDO.COD_CP,
                p_n_length => 5,
                p_s_char => v_nro_0
            ) DEUC_ID_CONCEPTO,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.NUM_CUO_PAT,
                p_n_length => 3,
                p_s_char => v_nro_0
            ) DEUC_NUMCUO,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_SALDO.COD_EST_CUO,
                p_n_length => 1,
                p_s_char => v_nro_0
            ) DEUC_ESTADO_CUOTA,
            FN_CNFG_LPAD(
                p_s_cadena => TO_CHAR(CNFGS_DT_SALDO.FEC_EST_CUO, 'YYYYMMDD'),
                p_n_length => 8,
                p_s_char => v_nro_0
            ) DEUC_FEC_ESTADO,
            FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_SALDO.IMP_PRD_CUO,
                    p_n_enteros => 7,
                    p_n_decimales => 4,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            DEUC_PARIDAD_CUOTA,
           FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_SALDO.IMP_CPL_MOR,
                    p_n_enteros => 13,
                    p_n_decimales => 4,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                ))
            DEUC_CAPITAL_MO,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_SALDO.IMP_INT_MOR,
                    p_n_enteros => 13,
                    p_n_decimales => 4,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                ))
             DEUC_INTERES_MO,
            FN_CNFG_FILLER(p_n_cantidad => 20) FILLER_20,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_SALDO.NUM_CCB_CPL,
                p_n_length => 11,
                p_s_char => v_nro_0
            ) DEUC_CAPITAL_CTACTBLE,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_SALDO.IMP_SDO_CPL,
                    p_n_enteros => 13,
                    p_n_decimales => 2,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUC_CAPITAL_MC,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_SALDO.NUM_CCB_INT,
                p_n_length => 11,
                p_s_char => v_nro_0
            ) DEUC_INTXCOB_CTACTBLE,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_SALDO.IMP_SDO_INT,
                    p_n_enteros => 13,
                    p_n_decimales => 2,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUC_INTXCOB_MC,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_SALDO.NUM_CCB_ISU,
                p_n_length => 11,
                p_s_char => v_nro_0
            ) DEUC_INTSUSP_CTACTBLE,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_SALDO.IMP_SDO_ISU,
                    p_n_enteros => 13,
                    p_n_decimales => 2,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUC_INTSUSP_MC,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_SALDO.NUM_CCB_REJ,
                p_n_length => 11,
                p_s_char => v_nro_0
            ) DEUC_REAXCOB_CTACTBLE,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_SALDO.IMP_SDO_REJ,
                    p_n_enteros => 13,
                    p_n_decimales => 2,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUC_REAXCOB_MC,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_SALDO.NUM_CCB_INT_CVA,
                p_n_length => 11,
                p_s_char => v_nro_0
            ) DEUC_REASUSP_CTACTBLE,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_MON_FTO(
                    p_n_monto => CNFGS_DT_SALDO.IMP_REJ_CVA,
                    p_n_enteros => 13,
                    p_n_decimales => 2,
                    p_s_tipo_moneda => CNFGS_DT_OPRCN.COD_MON_OPE_CMF
                )
            ) DEUC_REASUSP_MC,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.DSC_SIS_ORG,
                p_n_length => 3,
                p_s_char => v_nro_0
            ) DEUC_SIST_ORG,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.FLG_ISU,
                p_n_length => 11,
                p_s_char => v_nro_0
            ) CTA_SPD_DEV_CV,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_LPAD(
                    p_s_cadena => CNFGS_DT_SALDO.NUM_INT_CVA,
                    p_n_length => 15,
                    p_s_char => v_nro_0
                )
            ) MNT_SUSP_CV,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_SALDO.NUM_CCB_REJ_CVA,
                p_n_length => 11,
                p_s_char => v_nro_0
            ) CTA_REAJ_SUSP_CV,
            FN_CNFG_TRANSULTNUMSTR(
                p_s_numero => FN_CNFG_LPAD(
                    p_s_cadena => CNFGS_DT_SALDO.IMP_REJ_CVA,
                    p_n_length => 15,
                    p_s_char => v_nro_0
                )
            ) MNT_REAJ_SUSP_CV,
            FN_CNFG_RUT(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_RPB_OPE) DEUC_NRT_PPAL2,
			FN_CNFG_RUT_DV(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_RPB_OPE) DEUC_DRT_PPAL2,
            FN_CNFG_LPAD(
                p_s_cadena => CNFGS_DT_OPRCN.FLG_RPB_OPE,
                p_n_length => 1,
                p_s_char => v_nro_0
            ) DEUC_MARCA,
            FN_CNFG_RUT(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUC_NRT_PPAL3,
            FN_CNFG_RUT_DV(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_CLT) DEUC_DRT_PPAL3,
            FN_CNFG_FILLER(p_n_cantidad => 11) FILLER_11
        FROM
            CNFGS_DT_OPRCN,
            CNFGS_DT_SALDO
        WHERE
            CNFGS_DT_OPRCN.NUM_RUT_CLT = CNFGS_DT_SALDO.NUM_RUT_CLT
            AND CNFGS_DT_SALDO.NUM_IDE_REG = CNFGS_DT_OPRCN.NUM_IDE_REG
            AND CNFGS_DT_SALDO.NUM_END = CNFGS_DT_OPRCN.NUM_END
            AND CNFGS_DT_SALDO.COD_SUC_OPE = CNFGS_DT_OPRCN.COD_SUC_OPE
            AND CNFGS_DT_OPRCN.NUM_IDE_REG = v_d_fecha
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
        v_s_mensaje := 'SP_CNFG_INTFZ_CUOTA - '
                       || sqlcode
                       || ' - '
                       || sqlerrm
                       || ' - '
                       || dbms_utility.format_error_backtrace;

        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
END SP_CNFG_INTFZ_CUOTA;