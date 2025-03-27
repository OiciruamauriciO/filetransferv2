create or replace FUNCTION            "FN_CNFG_FILLER"(p_n_cantidad  NUMBER) RETURN VARCHAR2 IS
	/*************************************************************************************************
    Procedimiento: FN_CNFG_FILLER
    HU           : J00102-5937
    Objetivo:      Servicio que tiene como propósito devolver espacios vacíos en una cadena de texto larga.

    Sistema:       CNFCG
    Base de Datos: CONFIG_GLOBAL_DBO
    Tablas Usadas:
    Fecha:         29-10-2024
    Autor:         Mauricio González - Celula Ingenio
    Input:
                   p_cantidad

    Output:
                   v_espacios

    Observaciones:
    REVISIONES:
      Ver        Date        Author                Description
      ---------  ----------  -------------------   ------------------------------------
      m0         29-10-2024  Mauricio González     Version inicial
   --************************************************************************************************/
    v_n_espacio CONSTANT CHAR(1) := ' ';
	v_espacios 	VARCHAR2(200);
BEGIN
	v_espacios := FN_CNFG_RPAD(P_S_CADENA => ' ', P_N_LENGTH => p_n_cantidad , P_S_CHAR => v_n_espacio);
	RETURN v_espacios;
END;