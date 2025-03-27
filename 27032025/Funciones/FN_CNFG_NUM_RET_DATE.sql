create or replace FUNCTION            "FN_CNFG_NUM_RET_DATE" (p_n_fecha IN DATE)
RETURN NUMBER
IS
	/*************************************************************************************************
    Procedimiento: FN_CNFG_NUM_RET_DATE
    HU           : J00102-5939
    Objetivo:      Servicio que tiene como proposito transformar fechas en valor numerico.

    Sistema:       CNFCG
    Base de Datos: CONFIG_GLOBAL_DBO
    Tablas Usadas:
    Fecha:         03-10-2024
    Autor:         Jonatan Soto - Celula Ingenio
    Input:
                   p_n_fecha

    Output:
                   v_n_fecha

    Observaciones:
    REVISIONES:
      Ver        Date        Author                Description
      ---------  ----------  -------------------   ------------------------------------
      m0         03-10-2024  Jonatan Soto     Version inicial
   --************************************************************************************************/
    v_n_fecha NUMBER;
BEGIN
    v_n_fecha := TO_NUMBER(to_char(p_n_fecha, 'yyyymmdd'));
    RETURN v_n_fecha;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error al convertir el fecha a numero: ' || SQLERRM);
END FN_CNFG_NUM_RET_DATE;