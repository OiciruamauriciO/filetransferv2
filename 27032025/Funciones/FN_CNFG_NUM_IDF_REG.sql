create or replace FUNCTION            "FN_CNFG_NUM_IDF_REG" (
    p_s_fecha_valida IN VARCHAR2
) RETURN BOOLEAN IS
/*************************************************************************************************
    Procedimiento: FN_CNFG_NUM_IDF_REG
    HU           : J00102-5939
    Objetivo:      Servicio que tiene como proposito validar fecha.

    Sistema:       CNFCG
    Base de Datos: CONFIG_GLOBAL_DBO
    Tablas Usadas:
    Fecha:         18-12-2024
    Autor:         Jonatan Soto - Celula Ingenio
    Input:
                   p_v_fecha

    Output:
                   boolean

    Observaciones:
    REVISIONES:
      Ver        Date        Author                Description
      ---------  ----------  -------------------   ------------------------------------
      m0         18-12-2024  Jonatan Soto     Version inicial
   --************************************************************************************************/
    v_d_fecha DATE;
BEGIN
    v_d_fecha := TO_DATE ( p_s_fecha_valida, 'YYYYMMDD' );
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END FN_CNFG_NUM_IDF_REG;