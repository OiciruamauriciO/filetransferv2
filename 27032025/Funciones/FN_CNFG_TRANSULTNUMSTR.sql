create or replace FUNCTION            "FN_CNFG_TRANSULTNUMSTR" (
    p_s_numero IN VARCHAR2
) RETURN VARCHAR2 IS
	/*************************************************************************************************
    Procedimiento: FN_CNFG_RUT
    HU           : J00102-5937
    Objetivo:      Servicio que tiene como propósito devolver una cadena texto formateando el final de la salida con caracteres segun ultimo numero

    Sistema:       CNFCG
    Base de Datos: CONFIG_GLOBAL_DBO
    Tablas Usadas:
    Fecha:         19-02-2025
    Autor:         Jonatan Soto - Celula Ingenio
    Input:
                   P_S_NUMERO

    Output:
                   V_S_RESULTADO

    Observaciones:
    REVISIONES:
      Ver        Date        Author                Description
      ---------  ----------  -------------------   ------------------------------------
      m0         19-02-2025  Jonatan Soto     Version inicial
   --************************************************************************************************/
    v_n_car       NUMBER;
    v_s_dig       VARCHAR2(1);
    v_s_resultado VARCHAR2(100);
BEGIN
    v_n_car := TO_NUMBER ( substr(p_s_numero,
                                  length(p_s_numero),
                                  1) );
    IF instr(p_s_numero, '-') = 0 THEN
        CASE v_n_car
            WHEN 1 THEN
                v_s_dig := 'A';
            WHEN 2 THEN
                v_s_dig := 'B';
            WHEN 3 THEN
                v_s_dig := 'C';
            WHEN 4 THEN
                v_s_dig := 'D';
            WHEN 5 THEN
                v_s_dig := 'E';
            WHEN 6 THEN
                v_s_dig := 'F';
            WHEN 7 THEN
                v_s_dig := 'G';
            WHEN 8 THEN
                v_s_dig := 'H';
            WHEN 9 THEN
                v_s_dig := 'I';
            WHEN 0 THEN
                v_s_dig := '*';
        END CASE;

    ELSE
        CASE v_n_car
            WHEN 1 THEN
                v_s_dig := 'J';
            WHEN 2 THEN
                v_s_dig := 'K';
            WHEN 3 THEN
                v_s_dig := 'L';
            WHEN 4 THEN
                v_s_dig := 'M';
            WHEN 5 THEN
                v_s_dig := 'N';
            WHEN 6 THEN
                v_s_dig := 'O';
            WHEN 7 THEN
                v_s_dig := 'P';
            WHEN 8 THEN
                v_s_dig := 'Q';
            WHEN 9 THEN
                v_s_dig := 'R';
            WHEN 0 THEN
                v_s_dig := '*';
        END CASE;
    END IF;

    IF length(p_s_numero) > 1 THEN
        v_s_resultado := substr(p_s_numero, 1, length(p_s_numero) - 1)
                         || v_s_dig;
    ELSE
        v_s_resultado := v_s_dig;
    END IF;

    RETURN v_s_resultado;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(-20001, 'AN ERROR WAS ENCOUNTERED - '
                                        || sqlcode
                                        || ' - ERROR - '
                                        || sqlerrm);
END fn_cnfg_transultnumstr;