create or replace PROCEDURE          SP_CNFG_CNSTA_LLAVE(
   p_n_tipmov        IN     VARCHAR2,
   p_n_numope        IN     VARCHAR2,
   p_c_datos         OUT sys_refcursor,
   p_c_salida        OUT sys_refcursor
)
AS

/******************************************************************************
   NAME:       SP_CNFG_CNSTA_LLAVE
   PURPOSE:    El proposito de este procedimiento es entregar la llave de un movimiento

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24-09-2024          1. Created this procedure.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     SP_CNFG_CNSTA_LLAVE
      Sysdate:         24-09-2024
      Date and Time:   24-09-2024, 23:04:18, and 24-09-2024 23:04:18
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
   v_nro_neg_1 CONSTANT     NUMBER := -1;
   v_nro_1     CONSTANT  NUMBER := 1;
   v_vacio     CONSTANT  VARCHAR2(1) := '';
   v_n_retorno   NUMBER;
   v_s_mensaje   VARCHAR2(1000);
   pp_n_tipmov   NUMBER;
   pp_n_numope   VARCHAR2(20);
   e_m_parametro EXCEPTION;

BEGIN
   v_n_retorno   := 0;

   --SE CONTROLA CAMPOS DE ENTRADA POR HACKING ETICO
   BEGIN
        v_s_mensaje := 'Error, campo p_n_tipmov no cumple con el formato requerido.';
        pp_n_tipmov    := TO_NUMBER(p_n_tipmov);

        v_s_mensaje := 'Error, campo p_n_numope no cumple con el formato requerido.';
        pp_n_numope  := p_n_numope;

        v_s_mensaje   := 'OK';

   EXCEPTION
        WHEN OTHERS THEN
            v_n_retorno := v_nro_1;
   END;

   IF v_n_retorno = v_nro_1 THEN
        RAISE e_m_parametro;
   END IF;

   OPEN p_c_datos FOR
        SELECT v_nro_1 control,
             nvl( mc.NUM_REF_MVT,0 ) llave,
             mc.NUM_IDF_CLT Rut_Cli,
             mc.cod_bco cod_bco,
             mc.cod_tpo_cta tpo_cta,
             mc.num_cta num_cta,
             to_char(mc.fec_mvt_cta_clt,'dd/mm/yyyy') fec_mov,
             mc.cod_mon_mvt cod_mvt,
             mc.imp_mvt_clt mto_mvt
        FROM CNFGS_DT_MVNTO_CNFRG_GLBAL mc
        WHERE NUM_MVT_APO = pp_n_numope and TPO_MVT = pp_n_tipmov
        UNION
        SELECT v_nro_neg_1 control, '0' llave,
             v_vacio Rut_Cli,
             v_vacio cod_bco,
             0 tpo_cta,
             v_vacio num_cta,
             v_vacio fec_mov,
             v_vacio cod_mvt,
             0 mto_mvt
        FROM DUAL
        ORDER BY control DESC;

   p_c_salida    :=  fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno, p_s_mensaje   => v_s_mensaje);

EXCEPTION
   WHEN e_m_parametro THEN
      v_n_retorno    := v_nro_1;
      p_c_datos      := fn_cnfg_ret_vacio;
      p_c_salida     := fn_cnfg_ret_mensaje (p_n_retorno => v_n_retorno,
                                           p_s_mensaje => v_s_mensaje);
   WHEN NO_DATA_FOUND THEN
      v_n_retorno := v_nro_1;
      v_s_mensaje := 'No existe llave';
      p_c_datos   := fn_cnfg_ret_vacio;
      p_c_salida  := fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno,
                                         p_s_mensaje   => v_s_mensaje);
   WHEN OTHERS THEN
      v_n_retorno := v_nro_1;
      v_s_mensaje := 'MVNTO_CNFRG_GLBAL - ' || SQLCODE || ' - '|| SQLERRM || ' - ' || DBMS_UTILITY.format_error_backtrace;
      p_c_datos   := fn_cnfg_ret_vacio;
      p_c_salida  := fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno,
                                          p_s_mensaje   => v_s_mensaje);
END SP_CNFG_CNSTA_LLAVE;