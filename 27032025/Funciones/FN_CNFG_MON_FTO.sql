create or replace FUNCTION            "FN_CNFG_MON_FTO" (
    p_n_monto     IN NUMBER,
    p_n_enteros IN NUMBER,
    p_n_decimales   IN NUMBER,
    p_s_tipo_moneda IN VARCHAR2
) RETURN VARCHAR2 IS
    /*************************************************************************************************
    Procedimiento: FN_CNFG_MON_FTO
    HU           : J00102-5937
    Objetivo:      Este servicio redondea un monto específico según el tipo de moneda
                   proporcionado y entrega el resultado en un formato específico.
                   El servicio acepta parámetros como el monto a redondear, la cantidad de decimales
                   y enteros deseados, y el tipo de moneda (CLP o USD). Basándose en el tipo de moneda,
                   aplica el redondeo adecuado (truncamiento para CLP y redondeo para USD), y formatea el resultado.

    Sistema:       CNFCG
    Base de Datos: CONFIG_GLOBAL_DBO
    Tablas Usadas: *
    Fecha:         18-12-2024
    Autor:         Jonatan Soto - Celula Ingenio
    Input:
                   p_n_monto
                   p_n_decimales
                   p_n_enteros
                   p_s_tipo_moneda

    Output:
                   varchar2

    Observaciones:
    REVISIONES:
      Ver        Date        Author                Description
      ---------  ----------  -------------------   ------------------------------------
      m0         13-02-2025  Jonatan Soto          Version inicial
   --************************************************************************************************/
    v_s_tipo_moneda    VARCHAR2(10);
    v_s_moneda_formato VARCHAR2(1000);
    v_s_decimales VARCHAR2(1000);
    v_n_lpad NUMBER;
BEGIN
    -- extraer tipo de moneda
    v_s_tipo_moneda := upper(trim(p_s_tipo_moneda));
    -- decimales
    v_s_decimales := '.' || fn_cnfg_lpad(p_s_cadena => 0, p_n_length => p_n_decimales, p_s_char => 0);

    v_n_lpad := p_n_enteros + p_n_decimales;

    IF v_s_tipo_moneda = 'CLP' THEN
        v_s_moneda_formato := to_char(trunc(p_n_monto) ||  v_s_decimales);

    ELSIF v_s_tipo_moneda = 'USD' THEN
        v_s_moneda_formato := to_char(round(p_n_monto, p_n_decimales), 'FM999999999990' || v_s_decimales);
    ELSE
        v_s_moneda_formato := 0;
    END IF;

   RETURN fn_cnfg_lpad(p_s_cadena => replace(v_s_moneda_formato, '.', ''), p_n_length => v_n_lpad, p_s_char => 0);
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001, 'ERROR FN_CNFG_MON_FTO - '
                                        || sqlcode
                                        || ' - ERROR - '
                                        || sqlerrm);
END FN_CNFG_MON_FTO;