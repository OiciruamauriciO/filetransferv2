create or replace FUNCTION            "FN_CNFG_RET_MENSAJE" (
                           p_n_retorno in NUMBER,
                           p_s_mensaje   in VARCHAR2
                                            ) return  sys_refcursor
/******************************************************************************
 Procedimiento: fn_cnfg_ret_mensaje
 Objetivo:      Esta funci¿n tiene como proposito el devolver u ¿n cursor de
                mensaje salida
 Sistema:       Confirming Global
 Base de Datos: SCCONFGLO
 Tablas Usadas: N/A
 Fecha:         25/09/2024
 Autor:         Rene Estay - Celula Ingenio
 Input:

 Output:
 Retorno:       Cursor con los datos de salida
 Observaciones:
 REVISIONES:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------

******************************************************************************/
is
  l_c_datos sys_refcursor;
begin
   open l_c_datos for
              select p_n_retorno v_n_resultado,
                     p_s_mensaje v_s_mensaje
        from dual;
  return(l_c_datos);
exception
    WHEN Others THEN
         raise_application_error(-20998,Sqlcode||'-'||SQLERRM);

end fn_cnfg_ret_mensaje;