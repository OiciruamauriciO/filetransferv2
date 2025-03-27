create or replace FUNCTION            "FN_CNFG_RET_NUM_CTA" (
    p_n_param_1 IN VARCHAR2,
    p_n_param_2 IN VARCHAR2
) RETURN VARCHAR2 IS
    /*************************************************************************************************
    Procedimiento: FN_CNFG_RET_NUM_CTA
    HU           : J00102-5937
    Objetivo:      Servicio que obtiene el número de cuenta según los parámetros enviados

    Sistema:       CNFCG
    Base de Datos: CONFIG_GLOBAL_DBO
    Tablas Usadas: cnfgs_dt_prmto_gnrls
    Fecha:         10-03-2025
    Autor:         Jonatan Soto - Celula Ingenio
    Input:         p_n_param_1
                   p_n_param_2

    Output:        v_s_nro_cta

    Observaciones:
    REVISIONES:
      Ver        Date        Author                Description
      ---------  ----------  -------------------   ------------------------------------
      m0         10-03-2025  Jonatan Soto          Versión inicial
    --************************************************************************************************/
    v_s_nro_cta VARCHAR2(100);
BEGIN

    SELECT dsc_crt_pmt INTO v_s_nro_cta
    FROM (
        SELECT dsc_crt_pmt
        FROM cnfgs_dt_prmto_gnrls
        WHERE num_idf_pmt = p_n_param_1
          AND num_csf_pmt = p_n_param_2
        ORDER BY ROWNUM DESC
    ) WHERE ROWNUM = 1;

    RETURN v_s_nro_cta;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20001, 'No se encontró una cuenta con los parámetros proporcionados.');
    WHEN OTHERS THEN
        raise_application_error(-20002, 'Error al procesar los parámetros: ' || sqlerrm);
END FN_CNFG_RET_NUM_CTA;