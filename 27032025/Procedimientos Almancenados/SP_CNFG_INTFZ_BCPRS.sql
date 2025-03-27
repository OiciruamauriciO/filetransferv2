create or replace PROCEDURE            "SP_CNFG_INTFZ_BCPRS" (
    p_s_tipo IN VARCHAR2,
    p_s_fecha IN VARCHAR2,
    p_c_datos OUT SYS_REFCURSOR,
    p_c_salida OUT SYS_REFCURSOR
) AS
    /*************************************************************************************************
     Procedimiento: SP_CNFG_INTFZ_BCPRS
     HU           : J00102-5942
     Objetivo:      Servicio que tiene propósito principal permitir la consulta de información
     relacionada con personas o contratos. Mediante la especificación de fechas de alta y baja.

     Sistema:       CNFCG
     Base de Datos: CONFIG_GLOBAL_DBO
     Tablas Usadas: CNFGS_DT_OPRCN
     Fecha:         30-10-2024
     Autor:         Jonatan Soto - Celula Ingenio
     Input:         p_s_tipo
     p_s_fecha
     Output:        p_c_datos
     p_c_salida
     Observaciones:
     REVISIONES:
     Ver        Date        Author                Description
     ---------  ----------  -------------------   ------------------------------------
     m0         30-10-2024  Jonatan Soto     Version inicial
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

    IF p_s_tipo = 'C' THEN

    SELECT
        COUNT(cnfgs_dt_oprcn.num_end)
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
        1 AS control,
        -- INDEX
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.num_end,
            p_n_length => 4,
            p_s_char => v_nro_0
        ) AS kpec141v_pecdgent,
        -- CÓDIGO DE ENTIDAD (0035)
        fn_cnfg_lpad(
            p_s_cadena => v_c_espacio,
            p_n_length => 8,
            p_s_char => v_c_espacio
        ) AS kpec141v_penumper,
        -- ESPACIOS
        '81' || fn_cnfg_rpad(
            p_s_cadena => cnfgs_dt_oprcn.num_ope,
            p_n_length => 10,
            p_s_char => v_nro_0
        ) AS kpec141v_penumcon,
        -- NÚMERO DE CONTRATO
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_suc_ope,
            p_n_length => 4,
            p_s_char => v_nro_0
        ) AS kpec141v_pecodofi,
        -- CÓDIGO DE OFICINA DE ALTA (TC0050)
        '0035' AS kpec141v_pecodent,
        -- CÓDIGO DE ENTIDAD (0035)
        'TI' AS kpec141v_pecalpar,
        -- CALIDAD DE PARTICIPACIÓN DEL INTERVINIENTE (TC0313)
        '001' AS kpec141v_peordpar,
        -- ORDEN DE PARTICIPACIÓN EN EL CONTRATO (001)
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_pto_ope,
            p_n_length => 2,
            p_s_char => v_nro_0
        ) AS kpec141v_pecodpro,
        -- CÓDIGO DE PRODUCTO (TC0111)
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_spo_ope,
            p_n_length => 4,
            p_s_char => v_nro_0
        ) AS kpec141v_pecodsub,
        -- CÓDIGO DE SUB-PRODUCTO (TC0309)
        decode(
            tipo,
            'ALTA',
            '9999-12-31',
            to_char(sysdate, 'YYYY-MM-DD')
        ) AS kpec141v_pefecbrb,
        -- FECHA DE BAJA DE LA RELACIÓN (9999-12-31 PARA OPCIÓN ALTA)
        decode(tipo, 'ALTA', 'A', 'C') AS kpec141v_peestrel,
        -- ESTADO DE LA RELACIÓN (A ACTIVA C CANCELADA)
        10000 AS kpec141v_peresint,
        -- PORCENTAJE DE INTERVENCIÓN EN LA RELACIÓN (100)
        'N' AS kpec141v_pemarpaq,
        -- MARCA DE PERTENENCIA A PAQUETE (N)
        fn_cnfg_lpad(
            p_s_cadena => decode(tipo, 'ALTA', v_c_espacio, 'CA'),
            p_n_length => 2,
            p_s_char => v_c_espacio
        ) AS kpec141v_pemotbaj,
        -- MOTIVO DE BAJA (PARA OPCION A EN BLANCO, PARA OPCION C TC0178)
        fn_cnfg_rpad(
            p_s_cadena => 'R',
            p_n_length => 2,
            p_s_char => v_c_espacio
        ) AS kpec141v_petipdoc,
        -- TIPO DEL DOCUMENTO (R )
        fn_cnfg_lpad(
            p_s_cadena => FN_CNFG_RUT(p_s_rut => CNFGS_DT_OPRCN.NUM_RUT_CLT),
            p_n_length => 11,
            p_s_char => 0
        ) AS kpec141v_penumdoc,
        -- RUT DEL CLIENTE SIN GUIÓN, ALINEADO A LA DERECHA Y RELLENO CON CEROS EJ 00090014781
        fn_cnfg_lpad(
            p_s_cadena => v_c_espacio,
            p_n_length => 8,
            p_s_char => v_c_espacio
        ) AS kpec141v_peusualt,
        -- USUARIO DE ALTA (ESPACIOS)
        to_char(sysdate, 'YYYY-MM-DD') AS kpec141v_pefecalt,
        -- FECHA DE ALTA EN FORMATO AAAA-MM-DD
        fn_cnfg_rpad(
            p_s_cadena => (decode(tipo, 'ALTA', v_c_espacio, 'CNFCG')),
            p_n_length => 8,
            p_s_char => v_c_espacio
        ) AS kpec141v_peusumod,
        -- USUARIO DE MODIFICACIÓN (OPCION A ESPACIOS)
        fn_cnfg_lpad(
            p_s_cadena => v_c_espacio,
            p_n_length => 4,
            p_s_char => v_c_espacio
        ) AS kpec141v_petermod,
        -- TERMINAL DE MODIFICACIÓN (OPCIÓN A ESPACIOS)
        '0278' AS kpec141v_pesucmod,
        -- SUCURSAL DE MODIFICACIÓN (OPCIÓN A ESPACIOS)
        fn_cnfg_lpad(
            p_s_cadena => v_c_espacio,
            p_n_length => 26,
            p_s_char => v_c_espacio
        ) AS kpec141v_pehstamp,
        -- FECHA DE ACTUALIZACIÓN (ESPACIOS)
        decode(tipo, 'ALTA', 'A', 'B') AS kpec141v_peopcion -- OPCION A=ACTIVA C= CANCELADO
    FROM
        (
            SELECT
                num_ide_reg AS num_reg,
                CASE
                    WHEN trunc(fec_isu_ope) = trunc(sysdate)
                    AND trunc(fec_ult_pag) != trunc(sysdate) THEN 'ALTA'
                    WHEN trunc(fec_isu_ope) != trunc(sysdate)
                    or fec_ult_pag is null
                    AND trunc(fec_ult_pag) = trunc(sysdate) THEN 'BAJA'
                END AS tipo
            FROM
                cnfgs_dt_oprcn
            WHERE
                cnfgs_dt_oprcn.num_ide_reg = v_d_fecha
        ),
        cnfgs_dt_oprcn
    WHERE
        cnfgs_dt_oprcn.num_ide_reg = num_reg
    ORDER BY
        control DESC;

    ELSIF p_s_tipo = 'P' THEN

    SELECT
        COUNT(cnfgs_dt_oprcn.num_end)
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
        1 AS control,
        -- INDEX
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.num_end,
            p_n_length => 4,
            p_s_char => v_nro_0
        ) AS peec3402_pecdgent,
        -- CÓDIGO DE ENTIDAD (0035)
        '81' || fn_cnfg_rpad(
            p_s_cadena => cnfgs_dt_oprcn.num_ope,
            p_n_length => 10,
            p_s_char => v_nro_0
        ) AS peec3402_penumcon,
        -- NÚMERO DE CONTRATO

        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_suc_ope,
            p_n_length => 4,
            p_s_char => v_nro_0
        ) AS peec3402_pecodofi,
        -- CÓDIGO DE OFICINA DE ALTA (TC0050)
        '0035' AS peec3402_pecodent,
        -- CÓDIGO DE ENTIDAD (0035)
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_pto_ope,
            p_n_length => 2,
            p_s_char => v_nro_0
        ) AS peec3402_pecodpro,
        -- CÓDIGO DE PRODUCTO (TC0111)
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_spo_ope,
            p_n_length => 4,
            p_s_char => v_nro_0
        ) AS peec3402_pecodsub,
        -- CÓDIGO DE SUB-PRODUCTO (TC0309)
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_mon_ope,
            p_n_length => 3,
            p_s_char => v_nro_0
        ) AS peec3402_pecodmon,
        -- CÓDIGO DE MONEDA (TC0080)
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_suc_ope,
            p_n_length => 4,
            p_s_char => v_nro_0
        ) AS peec3402_pesucope,
        -- SUCURSAL DE LA OPERACIÓN (TC0050)
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_ecl_ope,
            p_n_length => 4,
            p_s_char => v_c_espacio
        ) AS peec3402_peofiope,
        -- OFICIAL DE LA OPERACIÓN (ESPACIOS O DEBE EXISTIR EN PEDT021 CON ESTADO ACTIVO)
        fn_cnfg_lpad(
            p_s_cadena => '3',
            p_n_length => 3,
            p_s_char => v_nro_0
        ) AS peec3402_pecanven,
        -- CANAL DE VENTA (TC0347)
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_eta_ope,
            p_n_length => 4,
            p_s_char => v_c_espacio
        ) AS peec3402_peofiven,
        -- OFICIAL DE VENTA (DEBE EXISTIR EN PEDT021 CON ESTADO ACTIVO)
        fn_cnfg_lpad(
            p_s_cadena => cnfgs_dt_oprcn.cod_eta_ope,
            p_n_length => 4,
            p_s_char => v_c_espacio
        ) AS peec3402_peoficom,
        -- OFICIAL COMERCIAL (ESPACIOS O DEBE EXISTIR EN PEDT021 CON ESTADO ACTIVO)
        fn_cnfg_lpad(
            p_s_cadena => '0',
            p_n_length => 10,
            p_s_char => v_nro_0
        ) AS peec3402_pesdoant,
        -- SALDO ANTERIOR (CEROS)
        fn_cnfg_lpad(
            p_s_cadena => '0',
            p_n_length => 10,
            p_s_char => v_nro_0
        ) AS peec3402_pesdopro,
        -- SALDO PROMEDIO (CEROS)
        to_char(cnfgs_dt_oprcn.fec_isu_ope, 'YYYY-MM-DD')
        AS peec3402_pefecini,
        -- FECHA DE INCIO DEL CONTRATO EN FORMATO AAAA-MM-DD
        decode(
            cnfgs_dt_oprcn.fec_isu_ope,
            NULL,
            '9999-12-31',
            to_char(sysdate, 'YYYY-MM-DD')
        ) AS peec3402_pefecter,
        -- FECHA DE TERMINO DE CONTRATO, SINO MÁXIMA PARA ALTAS
        decode(tipo, 'ALTA', 'A', 'C') AS peec3402_peestope,
        -- ESTADO DE LA RELACIÓN (A ACTIVA C CANCELADA)
        to_char(sysdate, 'YYYY-MM-DD') AS peec3402_pefecest,
        -- FECHA DEL ESTADO EN FORMATO AAAA-MM-DD
        fn_cnfg_lpad(
            p_s_cadena => decode(tipo, 'BAJA', 'CA', v_c_espacio),
            p_n_length => 2,
            p_s_char => v_c_espacio
        ) AS peec3402_pemotest,
        -- MOTIVO DE BAJA (PARA OPCION A EN BLANCO, PARA OPCION C TC0178)
        fn_cnfg_lpad(
            p_s_cadena => v_c_espacio,
            p_n_length => 2,
            p_s_char => v_c_espacio
        ) AS peec3402_pesubest,
        -- SUB-ESTADO (ESPACIOS)
        fn_cnfg_lpad(
            p_s_cadena => v_c_espacio,
            p_n_length => 8,
            p_s_char => v_c_espacio
        ) AS peec3402_perelban,
        -- RELACIÓN BANCARIA (ESPACIOS)
        fn_cnfg_rpad(
            p_s_cadena => 5,
            p_n_length => 20,
            p_s_char => v_c_espacio
        ) AS peec3402_pepaqper,
        -- ORIGEN DEL CONTRATO (5 ALINEADO A LA IZQUIERDA)
        '00' AS peec3402_peinfdet_l,
        -- INFORMACIÓN DETALLE (ZEROS)
        fn_cnfg_lpad(
            p_s_cadena => v_c_espacio,
            p_n_length => 120,
            p_s_char => v_c_espacio
        ) AS peec3402_peinfdet_t,
        -- INFORMACIÓN DETALLE (ESPACIOS)
        decode(tipo, 'ALTA', 'A', 'B') AS peec3402_peopcion
    FROM
        (
            SELECT
                num_ide_reg AS num_reg,
                CASE
                    WHEN trunc(fec_isu_ope) = trunc(sysdate) AND trunc(fec_ult_pag) != trunc(sysdate) THEN
                    'ALTA'
                    WHEN trunc(fec_isu_ope) != trunc(sysdate) AND trunc(fec_ult_pag) = trunc(sysdate)
                    or fec_ult_pag is null
                    THEN
                    'BAJA'
                END AS tipo
            FROM
                cnfgs_dt_oprcn
            WHERE
                 cnfgs_dt_oprcn.num_ide_reg = v_d_fecha
        ),
        cnfgs_dt_oprcn
    WHERE
        cnfgs_dt_oprcn.num_ide_reg = num_reg
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
        v_s_mensaje := 'SP_CNFG_INTFZ_BCPRS - '
                       || sqlcode
                       || ' - '
                       || sqlerrm
                       || ' - '
                       || dbms_utility.format_error_backtrace;

        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
END SP_CNFG_INTFZ_BCPRS;