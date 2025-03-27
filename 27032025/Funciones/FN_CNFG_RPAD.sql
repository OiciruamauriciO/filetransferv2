create or replace FUNCTION            "FN_CNFG_RPAD" (
    p_s_cadena IN CHAR,
    p_n_length IN NUMBER,
    p_s_char   IN CHAR
) RETURN VARCHAR2 IS
   --************************************************************************************************
   -- Funcion/Procedimiento: FN_CNFG_RPAD
   -- Objetivo: Funcion que tiene como proposito completar una variable string con un valor dado
   -- Sistema: CNFG - Contirming Global
   -- Base de Datos: DBO_CNFG
   -- Tablas Usadas: N/A
   -- Fecha: 20230725
   -- Autor: REstay / Banco
   -- Input: p_s_cadena   --> Variable original a se completada
   --        p_n_length   --> Largo total de la variable completada
   --        p_s_char     --> Caracter con el que se completa la variable
   -- Output: N/A
   -- Input/Output: N/A
   -- Retorno: Variable final completada con valor de relleno.
   -- Observaciones: N/A
   --***********************************************************************************************
    v_s_coderror CONSTANT NUMBER := -20001;
    v_c_space    VARCHAR2(32767);
    v_s_cadena   VARCHAR2(32767);
BEGIN

    v_s_cadena := p_s_cadena;

    IF p_n_length < length(v_s_cadena) THEN
        RETURN substr(str1 => v_s_cadena, pos => 1, len => p_n_length);
    ELSE
        v_c_space := lpad(p_s_char, p_n_length - length(v_s_cadena), p_s_char);
        RETURN substr(str1 => v_s_cadena || v_c_space, pos => 1, len => p_n_length);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        raise_application_error(v_s_coderror, sqlerrm);
END FN_CNFG_RPAD;