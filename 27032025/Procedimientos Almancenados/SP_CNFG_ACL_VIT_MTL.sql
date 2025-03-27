create or replace PROCEDURE            "SP_CNFG_ACL_VIT_MTL" (
    p_c_datos  OUT SYS_REFCURSOR,
    p_c_salida OUT SYS_REFCURSOR
) AS
    /*************************************************************************************************
    Procedimiento: SP_CNFG_ACL_VIT_MTL
    HU           : J00102-6225
    Objetivo:      Servicio que tiene como proposito actualizar vistas materializadas
    Sistema:       CNFCG
    Base de Datos: CONFIG_GLOBAL_DBO
    Tablas Usadas: *
    Vistas Usadas: PEDT001
                   PEDT002
                   PEDT003
                   PEDT021
                   PEDT084
                   TCDT040
                   TCDTBAI
                   TCDTGEN
    Fecha:         04-02-2025
    Autor:         Jonatan Soto - Celula Ingenio
    Input:         *
    Output:        p_c_datos
                   p_c_salida
    Observaciones:
    REVISIONES:
      Ver        Date        Author                Description
      ---------  ----------  -------------------   ------------------------------------
      m0         17-10-2024  Jonatan Soto     Version inicial
   --************************************************************************************************/

   --p_c_cursor             sys_refcursor;
   ----------------------------------
   --Variables y Constantes Locales--
   ----------------------------------
    v_n_retorno NUMBER := 0;
    v_s_mensaje VARCHAR2(1000) := 'OK';
    v_s_owner   VARCHAR2(20) := 'DBO_CNFG';

BEGIN

    pkg_dba.refresh_mview_10g(mview_name_in => 'PEDT001');
    pkg_dba.refresh_mview_10g(mview_name_in => 'PEDT002');
    pkg_dba.refresh_mview_10g(mview_name_in => 'PEDT003');
    pkg_dba.refresh_mview_10g(mview_name_in => 'PEDT021');
    pkg_dba.refresh_mview_10g(mview_name_in => 'PEDT084');
    pkg_dba.refresh_mview_10g(mview_name_in => 'TCDT040');
    pkg_dba.refresh_mview_10g(mview_name_in => 'TCDTBAI');
    pkg_dba.refresh_mview_10g(mview_name_in => 'TCDTGEN');

    OPEN p_c_datos FOR SELECT
                                              mview_name,
                                              last_refresh_date,
                                              last_refresh_type
                                          FROM
                                              all_mviews
                       WHERE
                          owner = v_s_owner AND  mview_name IN (  'PEDT001', 'PEDT002', 'PEDT003', 'PEDT021', 'PEDT084', 'TCDT040', 'TCDTBAI', 'TCDTGEN' );

    p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);

EXCEPTION
    WHEN no_data_found THEN
        v_n_retorno := 1;
        v_s_mensaje := 'No se encontraron datos';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN OTHERS THEN
        v_n_retorno := 1;
        v_s_mensaje := 'Error en SP_CNFG_ACL_VIT_MTL - '
                       || sqlcode
                       || ' - '
                       || sqlerrm
                       || ' - '
                       || dbms_utility.format_error_backtrace;
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
END SP_CNFG_ACL_VIT_MTL;
