create or replace FUNCTION fn_cnfg_rdr_fmt (
    p_n_valor   IN NUMBER,
    p_c_prefijo IN CHAR
) RETURN VARCHAR2 IS
    /*************************************************************************************************
    PROCEDIMIENTO: FN_CNFG_RDR_FMT
    HU           : J00102-5937
    OBJETIVO     : Redondear un número a 4 decimales y agregar prefijo según el parámetro ('K' para '+', 'I' para '-')
    SISTEMA      : CNFCG
    BASE DE DATOS: CONFIG_GLOBAL_DBO
    TABLAS USADAS: *
    FECHA        : 18-03-2025
    AUTOR        : JONATAN SOTO - CELULA INGENIO
    INPUT        : p_n_valor (Número a redondear), p_c_prefijo ('K' o 'I')
    OUTPUT       : Valor redondeado y formateado como VARCHAR2 de 18 caracteres

    OBSERVACIONES:
    REVISIONES:
      VER        DATE        AUTHOR                DESCRIPTION
      ---------  ----------  -------------------   ------------------------------------
      M0         18-03-2025 JONATAN SOTO          VERSIÓN INICIAL
   --************************************************************************************************/
    v_n_valor_redondeado VARCHAR2(18); -- Variable para valor procesado
    v_s_prefijo          VARCHAR2(1);  -- Variable para prefijo
    v_s_resultado        VARCHAR2(18); -- Variable para resultado final
BEGIN
    IF p_c_prefijo = 'K' THEN
        v_s_prefijo := '+';
    ELSIF p_c_prefijo = 'I' THEN
        v_s_prefijo := '-';
    ELSE
        v_s_prefijo := ''; 
    END IF;

    v_n_valor_redondeado := TO_CHAR(ROUND(p_n_valor, 4), 'FM9999999999999.0000');

    v_n_valor_redondeado := FN_CNFG_LPAD(
        P_S_CADENA => REPLACE(v_n_valor_redondeado, '.', ''), 
        P_N_LENGTH => 17,
        P_S_CHAR   => '0'
    );

    v_s_resultado := v_s_prefijo || v_n_valor_redondeado;

    IF LENGTH(v_s_resultado) > 18 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El valor formateado excede el límite de 18 caracteres.');
    END IF;

    RETURN v_s_resultado;

EXCEPTION
    WHEN VALUE_ERROR THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error en el procesamiento: valor no válido.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error inesperado: ' || SQLERRM);
END fn_cnfg_rdr_fmt;