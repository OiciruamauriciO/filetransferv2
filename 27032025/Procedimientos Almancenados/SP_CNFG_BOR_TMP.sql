create or replace PROCEDURE            "SP_CNFG_BOR_TMP" (
    p_s_tabla  IN VARCHAR2,
    p_c_datos  OUT SYS_REFCURSOR,
    p_c_salida OUT SYS_REFCURSOR
) AS

    /*************************************************************************************************
    Procedimiento   : SP_CNFG_BOR_TMP
    HU              : J00102-6061
    Objetivo        : Servicio disenado para vaciar las tablas temporales.
    Sistema         : CNFCG
    Base de Datos   : CONFIG_GLOBAL_DBO
    Tablas Usadas   :   CNFGS_IN_BANKS
                        CNFGS_IN_CLIENTS
                        CNFGS_IN_CONTARCSTGLOBAL
                        CNFGS_IN_CONTARCSTGLOBALSAN
                        CNFGS_IN_FEEDETAILSGGLOBAL
                        CNFGS_IN_FEEDETAILSSAN
                        CNFGS_IN_FISCALDATA
                        CNFGS_IN_FLOW
                        CNFGS_IN_INVOICE
                        CNFGS_IN_PARTICIPANTS
                        CNFGS_IN_STRATUS
                        CNFGS_IN_SUPPLIERS
                        CNFGS_IN_SUPPLIERSADDRESS
                        CNFGS_IN_SUPPLIERSNAME
                        CNFGS_IN_TERM
    Fecha           : 28-01-2025
    Autor           : Jonatan Soto Imio - Celula Ingenio
    Input           : p_s_tabla
    Output          : p_c_datos
                      p_c_salida

    REVISIONES:
      Ver        Date        Author                Description
      ---------  ----------  -------------------   ------------------------------------
      m0         28-01-2025  Jonatan Soto Imio     Version inicial
   --************************************************************************************************/
   ----------------------------------
   --Variables y Constantes Locales--
   ----------------------------------
    v_n_retorno NUMBER := 0;
    v_n_count   NUMBER := 0;
    v_n_filas   NUMBER := 0;
	v_s_owner  VARCHAR2(20) := 'DBO_CNFG';
    v_s_mensaje VARCHAR2(1000) := 'OK';
    e_no_encontro EXCEPTION;
    e_no_data EXCEPTION;
BEGIN

    SELECT
        COUNT(table_name)
    INTO v_n_count
    FROM
        all_tables
    WHERE
        owner = v_s_owner and table_name IN ( p_s_tabla );

    IF v_n_count = 0 THEN
        RAISE e_no_encontro;
    END IF;

    PKG_DBA.stats_table (p_s_tabla);

    SELECT
        num_rows
    INTO v_n_filas
    FROM
        all_tables
    WHERE
        owner = v_s_owner and table_name IN ( p_s_tabla );

    IF v_n_filas = 0 THEN
        RAISE e_no_data;
    END IF;

    pkg_dba.truncate_table(p_s_tabla);

    OPEN p_c_datos FOR SELECT
                           p_s_tabla AS table_name,
                           v_n_filas AS rows_deleted
                       FROM
                           dual;

    p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);

EXCEPTION
    WHEN e_no_encontro THEN
        v_n_retorno := 1;
        v_s_mensaje := 'La tabla no se encuentra disponible';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN e_no_data THEN
        v_n_retorno := 1;
        v_s_mensaje := 'La tabla esta vacia, no se realizo ninguna accion';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN no_data_found THEN
        v_n_retorno := 1;
        v_s_mensaje := 'No existe llave';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN OTHERS THEN
        v_n_retorno := 1;
        v_s_mensaje := 'SP_CNFG_BOR_TMP - '
                       || sqlcode
                       || ' - '
                       || sqlerrm
                       || ' - '
                       || dbms_utility.format_error_backtrace;

        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);

END SP_CNFG_BOR_TMP;