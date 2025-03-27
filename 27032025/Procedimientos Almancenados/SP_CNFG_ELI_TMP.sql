create or replace PROCEDURE            "SP_CNFG_ELI_TMP" (
    p_n_dias   IN NUMBER,
    p_c_datos  OUT SYS_REFCURSOR,
    p_c_salida OUT SYS_REFCURSOR
)
AS
    /*************************************************************************************************
    Procedimiento: SP_CNFG_ELI_TMP
    HU           : J00102-5939
    Objetivo:      Servicio que tiene como proposito vaciar tablas temporales

    Sistema:       CNFCG
    Base de Datos: CONFIG_GLOBAL_DBO
    Tablas Usadas:
    Fecha:         03-10-2024
    Autor:         Jonatan Soto - Celula Ingenio
    Input:
                   p_n_dias,

    Output:
                   p_c_datos
                   p_c_salida
    Observaciones:
    REVISIONES:
      Ver        Date        Author                Description
      ---------  ----------  -------------------   ------------------------------------
      m0         03-10-2024  Jonatan Soto     Version inicial
   --************************************************************************************************/

   --p_c_cursor             sys_refcursor;
   ----------------------------------
   --Variables y Constantes Locales--
   ----------------------------------

    v_d_fecha DATE := trunc(sysdate-p_n_dias, 'DD');
    v_d_fecha_maxima NUMBER := fn_cnfg_num_ret_date(v_d_fecha);

    v_n_retorno        NUMBER := 0;
    v_s_mensaje        VARCHAR2(1000) := 'OK';
    e_no_encontro EXCEPTION;
    v_n_actualiza      NUMBER := 0;

BEGIN

    DELETE FROM cnfgs_dt_oprcn WHERE num_ide_reg <= v_d_fecha_maxima;

    v_n_actualiza := v_n_actualiza+SQL%rowcount;

    DELETE FROM cnfgs_dt_saldo WHERE num_ide_reg <= v_d_fecha_maxima;

    v_n_actualiza := v_n_actualiza+SQL%rowcount;

    IF v_n_actualiza = 0 THEN
        RAISE e_no_encontro;
    END IF;

    OPEN p_c_datos FOR SELECT 1 AS control, v_n_actualiza AS llave FROM dual
                       UNION
                       SELECT -1 AS control, 0 AS llave FROM dual
                       ORDER BY control DESC;

    p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);

EXCEPTION
    WHEN e_no_encontro THEN
        v_n_retorno := 1;
        v_s_mensaje := 'No existen datos en el rango de fecha';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN OTHERS THEN
        v_n_retorno := 1;
        v_s_mensaje := 'Error en SP_CNFG_ELI_TMP - '
                       || SQLCODE || ' - ' || SQLERRM
                       || ' - ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
END SP_CNFG_ELI_TMP;