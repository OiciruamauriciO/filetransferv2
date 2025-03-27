create or replace FUNCTION            "FN_CNFG_BSR_COD_PGO" (
    p_d_fecha  IN DATE,
    p_s_estado IN VARCHAR2
) RETURN NUMBER IS
    /*************************************************************************************************
    PROCEDIMIENTO: FN_CNFG_BSR_COD_PGO
    HU           : J00102-5937
    OBJETIVO:      ESTE SERVICIO TIENE PROPOSITO DEVOLVER UN CODIGO SEGUN SU ESTADO Y FECHA
    SISTEMA:       CNFCG
    BASE DE DATOS: CONFIG_GLOBAL_DBO
    TABLAS USADAS: *
    FECHA:         18-02-2025
    AUTOR:         JONATAN SOTO - CELULA INGENIO
    INPUT:
                   P_D_FECHA
                   P_S_ESTADO
    OUTPUT:
                   NUMBER

    OBSERVACIONES:
    REVISIONES:
      VER        DATE        AUTHOR                DESCRIPTION
      ---------  ----------  -------------------   ------------------------------------
      M0         18-02-2025 JONATAN SOTO          VERSION INICIAL
   --************************************************************************************************/
    v_n_codigo          NUMBER;
    v_n_dias_diferencia NUMBER;
BEGIN
    v_n_dias_diferencia := trunc(p_d_fecha) - trunc(sysdate);
    IF upper(p_s_estado) = 'DEAD' OR upper(p_s_estado) = 'LIVE' THEN
        v_n_codigo := 0;
    ELSIF v_n_dias_diferencia > 2 * 365 THEN
        v_n_codigo := 1;
    ELSIF
        v_n_dias_diferencia >= 90
        AND v_n_dias_diferencia < 365
    THEN
        v_n_codigo := 2;
    ELSIF
        v_n_dias_diferencia >= 0
        AND v_n_dias_diferencia < 90
    THEN
        v_n_codigo := 3;
    ELSIF trunc(p_d_fecha) > trunc(sysdate) THEN
        v_n_codigo := 4;
    ELSE
        v_n_codigo := NULL;
    END IF;
    RETURN v_n_codigo;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20002, 'Error al procesar el RUT: ' || sqlerrm);
END FN_CNFG_BSR_COD_PGO;