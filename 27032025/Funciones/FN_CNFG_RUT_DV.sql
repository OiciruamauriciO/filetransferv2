create or replace FUNCTION            "FN_CNFG_RUT_DV" (
    p_s_rut IN VARCHAR2
) RETURN VARCHAR2 IS
	/*************************************************************************************************
    Procedimiento: FN_CNFG_RUT_DV
    HU           : J00102-5937
    Objetivo:      Servicio que tiene como propósito devolver el digito verificador de un rut

    Sistema:       CNFCG
    Base de Datos: CONFIG_GLOBAL_DBO
    Tablas Usadas:
    Fecha:         19-02-2025
    Autor:         Jonatan Soto - Celula Ingenio
    Input:
                   P_S_RUT

    Output:
                   V_S_DV

    Observaciones:
    REVISIONES:
      Ver        Date        Author                Description
      ---------  ----------  -------------------   ------------------------------------
      m0         19-02-2025  Jonatan Soto     Version inicial
   --************************************************************************************************/

    v_s_rut_trim VARCHAR(20);
    v_s_dv       VARCHAR2(1);
    v_s_rgx      CONSTANT VARCHAR(20) := '[^-]+$';
BEGIN
    v_s_rut_trim := trim(p_s_rut);
    v_s_dv := regexp_substr(v_s_rut_trim, v_s_rgx);
    RETURN v_s_dv;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20002, 'Error al procesar el RUT: ' || sqlerrm);
END fn_cnfg_rut_dv;