create or replace FUNCTION            "FN_CNFG_LPAD"(
    p_s_cadena IN CHAR,
    p_n_length IN NUMBER,
    p_s_char   IN CHAR
) RETURN VARCHAR2 IS
   --************************************************************************************************
   -- Funcion/Procedimiento: FN_CNFG_LPAD
   -- Objetivo: Funcion que tiene como proposito completar una variable string con un valor dado
   -- Sistema: CNFG - Contirming Global
   -- Base de Datos: DBO_CNFG
   -- Tablas Usadas: N/A
   -- Fecha: 2024-10-17
   -- Autor: Rene Estay / Banco
   -- Input: p_s_cadena   --> Variable original a ser completada
   --        p_n_length   --> Largo total de la variable completada
   --        p_s_char     --> Caracter con el que se completa la variable
   -- Output: N/A
   -- Input/Output: N/A
   -- Retorno: Variable final completada con valor de relleno.
   -- Observaciones: N/A
   --***********************************************************************************************
    v_s_coderror CONSTANT NUMBER := -20001;
    v_c_space    VARCHAR2(32767);
    v_s_cadena varchar2(32767);

BEGIN

     v_s_cadena := p_s_cadena;

    IF v_s_cadena IS NULL THEN
        v_s_cadena := p_s_char;
    END IF;

    IF p_n_length < LENGTH(v_s_cadena) THEN
        RETURN SUBSTR(v_s_cadena, 1, p_n_length);
    ELSE
        v_c_space := LPAD(p_s_char, p_n_length - LENGTH(v_s_cadena), p_s_char);
        RETURN SUBSTR(v_c_space || v_s_cadena, 1, p_n_length);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(v_s_coderror, SQLERRM);
END FN_CNFG_LPAD;