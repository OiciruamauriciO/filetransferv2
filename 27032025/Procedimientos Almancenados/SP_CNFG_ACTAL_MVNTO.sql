create or replace PROCEDURE            "SP_CNFG_ACTAL_MVNTO" (
  p_n_tpo_mvt        IN     VARCHAR2,
  p_n_num_ref_mvt    IN     VARCHAR2,
  p_n_num_mvt_apo    IN     VARCHAR2,
  p_n_cod_est_mvt    IN     VARCHAR2,
  p_n_cod_usr_est    IN     VARCHAR2,
  p_c_datos         OUT sys_refcursor,
  p_c_salida        OUT sys_refcursor
) IS

/******************************************************************************
   NAME:       SP_CNFG_ACTAL_MVNTO
   PURPOSE:    Tiene como propósito el actualizar un registro de movimientos de pago o abono

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        24-09-2024          1. Created this procedure.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     SP_CNFG_ACTAL_MVNTO
      Sysdate:         24-09-2024
      Date and Time:   24-09-2024, 23:41:22, and 24-09-2024 23:41:22
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
   e_m_parametro EXCEPTION;
   v_n_retorno   NUMBER;
   v_s_mensaje   VARCHAR2 (1000);
   e_no_encontro exception;
   v_n_actualiza NUMBER := 0;

   pp_n_tpo_mvt     NUMBER;
   pp_n_num_ref_mvt VARCHAR2(20);
   pp_n_num_mvt_apo VARCHAR2(20);
   pp_n_cod_est_mvt CHAR(5);
   pp_n_cod_usr_est VARCHAR2(12);

BEGIN
   v_n_retorno   := 0;

   --SE CONTROLA CAMPOS DE ENTRADA POR HACKING ETICO
   BEGIN
        v_s_mensaje := 'Error, campo p_n_tpo_mvt no cumple con el formato requerido.';
        pp_n_tpo_mvt      := TO_NUMBER(p_n_tpo_mvt);

        v_s_mensaje := 'Error, campo p_n_num_ref_mvt no cumple con el formato requerido.';
        pp_n_num_ref_mvt  := p_n_num_ref_mvt;

        v_s_mensaje := 'Error, campo p_n_num_mvt_apo no cumple con el formato requerido.';
        pp_n_num_mvt_apo  := p_n_num_mvt_apo;

        v_s_mensaje := 'Error, campo p_n_cod_est_mvt no cumple con el formato requerido.';
        pp_n_cod_est_mvt  := p_n_cod_est_mvt;

        v_s_mensaje := 'Error, campo p_n_cod_usr_est no cumple con el formato requerido.';
        pp_n_cod_usr_est  := p_n_cod_usr_est;

        v_s_mensaje   := 'OK';

   EXCEPTION
        WHEN OTHERS THEN
            v_n_retorno := 1;
   END;

   IF v_n_retorno = 1 THEN
        RAISE e_m_parametro;
   END IF;


   UPDATE   CNFGS_DT_MVNTO_CNFRG_GLBAL mc
      SET   NUM_MVT_APO = DECODE (pp_n_num_mvt_apo, '-1', NUM_MVT_APO, pp_n_num_mvt_apo),
            COD_EST_MVT = DECODE (pp_n_cod_est_mvt, '-1', COD_EST_MVT, pp_n_cod_est_mvt),
            FEC_HRA_EST = SYSDATE,
            COD_USR_EST = pp_n_cod_usr_est
    WHERE       TPO_MVT     = pp_n_tpo_mvt
            AND NUM_REF_MVT = pp_n_num_ref_mvt;
   v_n_actualiza := sql%ROWCOUNT;
   IF v_n_actualiza = 0
   THEN
        RAISE e_no_encontro;
   END IF;
   OPEN p_c_datos FOR
      SELECT 1 control,
             v_n_actualiza llave
        FROM dual
      UNION
      SELECT -1 control, 0 llave FROM DUAL
      ORDER BY control DESC;

   p_c_salida    :=
      fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno,
                          p_s_mensaje   => v_s_mensaje);
EXCEPTION
   WHEN e_m_parametro THEN
      v_n_retorno    := 1;
      p_c_datos      := fn_cnfg_ret_vacio;
      p_c_salida     := fn_cnfg_ret_mensaje (p_n_retorno => v_n_retorno,
                                           p_s_mensaje => v_s_mensaje);
   WHEN e_no_encontro THEN
      v_n_retorno := 1;
      v_s_mensaje := 'No existe llave';
      p_c_datos   := fn_cnfg_ret_vacio;
      p_c_salida  := fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno,
                                          p_s_mensaje   => v_s_mensaje);

   WHEN NO_DATA_FOUND THEN
      v_n_retorno := 1;
      v_s_mensaje := 'No existe llave';
      p_c_datos   := fn_cnfg_ret_vacio;
      p_c_salida  := fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno,
                                          p_s_mensaje   => v_s_mensaje);
   WHEN OTHERS THEN
      v_n_retorno := 1;
      v_s_mensaje := 'MVNTO_CNFRG_GLBAL - ' || SQLCODE || ' - '|| SQLERRM || ' - ' || DBMS_UTILITY.format_error_backtrace;
      p_c_datos   := fn_cnfg_ret_vacio;
      p_c_salida  := fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno,
                                          p_s_mensaje   => v_s_mensaje);
END SP_CNFG_ACTAL_MVNTO;