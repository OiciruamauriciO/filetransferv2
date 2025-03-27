create or replace FUNCTION fn_cnfg_ect_tpo_utlzc (
    p_tipo_utilizacion IN VARCHAR2
) RETURN VARCHAR2 IS
    v_s_tipo_utilizacion VARCHAR2(1);
BEGIN
    v_s_tipo_utilizacion := substr(p_tipo_utilizacion, instr(p_tipo_utilizacion, '-', instr(p_tipo_utilizacion, '-') + 1) + 2, 1);

    v_s_tipo_utilizacion := upper(v_s_tipo_utilizacion);
    RETURN v_s_tipo_utilizacion;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'OTRO';
END fn_cnfg_ect_tpo_utlzc;