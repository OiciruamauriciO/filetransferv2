create or replace FUNCTION            "FN_CNFG_RET_VACIO" return  sys_refcursor
/******************************************************************************
 Procedimiento: FN_CNFG_RET_VACIO
 Objetivo:      Esta funci¿n tiene como proposito el devolver u ¿n cursor vacio

 Sistema:       CONFIRMING GLOBAL
 Base de Datos: SCCONFGLO
 Tablas Usadas: N/A
 Fecha:         25/09/2024
 Autor:         Rene Estay - Celula Ingenio
 Input:

 Output:
 Retorno:       Cursor vacio
 Observaciones:
 REVISIONES:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------

******************************************************************************/
is
  l_c_datos sys_refcursor;
begin
   open l_c_datos for
              select -1 Cod_retorno,
               'No hay Datos' Mensaje
        from dual;
  return(l_c_datos);
exception
    WHEN Others THEN
         raise_application_error(-20998,Sqlcode||'-'||SQLERRM);

end fn_cnfg_ret_vacio;