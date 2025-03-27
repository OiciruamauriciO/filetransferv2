create or replace PROCEDURE          SP_CNFG_GRABA_MVNTO (p_n_tpo_mvt       IN     VARCHAR2,
                                                          p_n_num_ref_mvt   IN     VARCHAR2,
                                                          p_n_num_idf_clt   IN     VARCHAR2,
                                                          p_n_cod_bco       IN     VARCHAR2,
                                                          p_n_cod_tpo_cta   IN     VARCHAR2,
                                                          p_n_num_cta       IN     VARCHAR2,
                                                          p_n_fec_mvt_cta   IN     VARCHAR2,
                                                          p_n_cod_mon_mvt   IN     VARCHAR2,
                                                          p_n_imp_mvt_clt   IN     VARCHAR2,
                                                          p_n_num_mvt_apo   IN     VARCHAR2,
                                                          p_n_cod_est_mvt   IN     VARCHAR2,
                                                          p_n_cod_usr_est   IN     VARCHAR2,
                                                          p_n_cod_usr_crc   IN     VARCHAR2,
                                                          p_c_datos            OUT sys_refcursor,
                                                          p_c_salida           OUT sys_refcursor)
IS
   /******************************************************************************
      NAME:       SP_CNFG_GRABA_MVNTO
      PURPOSE:    Servicio que registra informacion del pago/cobro enviado por Global.

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        24-09-2024  REP-AAG          J00102-5974 Version inicial.
   ******************************************************************************/
   e_m_parametro exception;
   v_nro_0 CONSTANT       NUMBER := 0;
   v_nro_1 CONSTANT       NUMBER := 1;
   v_nro_neg_1 CONSTANT   NUMBER := -1;
   v_s_nro_0 CONSTANT     CHAR (1) := '0';
   v_n_retorno            NUMBER;
   v_s_mensaje            VARCHAR2 (1000);
   v_n_tpo_mvt            NUMBER (1);
   v_n_num_ref_mvt        VARCHAR2 (20);
   v_n_num_idf_clt        VARCHAR2 (12);
   v_n_cod_bco            CHAR (4);
   v_n_cod_tpo_cta        NUMBER (2);
   v_n_num_cta            VARCHAR2 (20);
   v_n_fec_mvt_cta        DATE;
   v_n_cod_mon_mvt        CHAR (3);
   v_n_imp_mvt_clt        NUMBER (19, 4);
   v_n_num_mvt_apo        VARCHAR2 (20);
   v_n_cod_est_mvt        CHAR (5);
   v_n_cod_usr_est        VARCHAR2 (12);
   v_n_cod_usr_crc        VARCHAR2 (12);
BEGIN
   v_n_retorno   := v_nro_0;
   v_s_mensaje   := 'OK';

   -- validacion tipo de datos de entrada
   BEGIN
      v_s_mensaje       := 'p_n_tpo_mvt';
      v_n_tpo_mvt       := TO_NUMBER (p_n_tpo_mvt);

      v_s_mensaje       := 'p_n_num_ref_mvt';
      v_n_num_ref_mvt   := p_n_num_ref_mvt;

      v_s_mensaje       := 'p_n_num_idf_clt';
      v_n_num_idf_clt   := p_n_num_idf_clt;

      v_s_mensaje       := 'p_n_cod_bco';
      v_n_cod_bco       := p_n_cod_bco;

      v_s_mensaje       := 'p_n_cod_tpo_cta';
      v_n_cod_tpo_cta   := TO_NUMBER (p_n_cod_tpo_cta);

      v_s_mensaje       := 'p_n_num_cta';
      v_n_num_cta       := p_n_num_cta;

      v_s_mensaje       := 'p_n_fec_mvt_cta';
      v_n_fec_mvt_cta   := TO_DATE (p_n_fec_mvt_cta, 'dd-mm-yyyy');

      v_s_mensaje       := 'p_n_cod_mon_mvt';
      v_n_cod_mon_mvt   := p_n_cod_mon_mvt;

      v_s_mensaje       := 'p_n_imp_mvt_clt';
      v_n_imp_mvt_clt   := TO_NUMBER (p_n_imp_mvt_clt);

      v_s_mensaje       := 'p_n_num_mvt_apo';
      v_n_num_mvt_apo   := p_n_num_mvt_apo;

      v_s_mensaje       := 'p_n_cod_est_mvt';
      v_n_cod_est_mvt   := p_n_cod_est_mvt;

      v_s_mensaje       := 'p_n_cod_usr_est';
      v_n_cod_usr_est   := p_n_cod_usr_est;

      v_s_mensaje       := 'p_n_cod_usr_crc';
      v_n_cod_usr_crc   := p_n_cod_usr_crc;

      v_s_mensaje       := 'OK';
   EXCEPTION
      WHEN OTHERS THEN
         v_s_mensaje   :=
            'Error, ' || v_s_mensaje || ' no cumple el formato requerido.';
         v_n_retorno   := v_nro_neg_1;
         RAISE e_m_parametro;
   END;

   -- validar datos obligatorios
   IF NVL (v_n_tpo_mvt, v_nro_0) = v_nro_0 THEN
      v_s_mensaje   := 'Error, p_n_tpo_mvt es requerido.';
      RAISE e_m_parametro;

   ELSIF NVL (v_n_num_ref_mvt, v_s_nro_0) = v_s_nro_0 THEN
      v_s_mensaje   := 'Error, p_n_num_ref_mvt es requerido.';
      RAISE e_m_parametro;
   END IF;

   INSERT INTO cnfgs_dt_mvnto_cnfrg_glbal (tpo_mvt,
                                           num_ref_mvt,
                                           num_idf_clt,
                                           cod_bco,
                                           cod_tpo_cta,
                                           num_cta,
                                           fec_mvt_cta_clt,
                                           cod_mon_mvt,
                                           imp_mvt_clt,
                                           num_mvt_apo,
                                           cod_est_mvt,
                                           fec_hra_est,
                                           cod_usr_est,
                                           fec_hra_crc,
                                           cod_usr_crc)
   VALUES (v_n_tpo_mvt,
           v_n_num_ref_mvt,
           v_n_num_idf_clt,
           v_n_cod_bco,
           v_n_cod_tpo_cta,
           v_n_num_cta,
           v_n_fec_mvt_cta,
           v_n_cod_mon_mvt,
           v_n_imp_mvt_clt,
           v_n_num_mvt_apo,
           v_n_cod_est_mvt,
           SYSDATE,
           v_n_cod_usr_est,
           SYSDATE,
           v_n_cod_usr_crc);

   p_c_datos     := fn_cnfg_ret_vacio;

   v_n_retorno   := v_nro_0;
   v_s_mensaje   := 'OK';
   p_c_salida    :=
      fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno,
                           p_s_mensaje   => v_s_mensaje);
EXCEPTION
   WHEN e_m_parametro THEN
      v_n_retorno   := v_nro_1;
      p_c_datos     := fn_cnfg_ret_vacio;
      p_c_salida    :=
         fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno,
                              p_s_mensaje   => v_s_mensaje);
   WHEN DUP_VAL_ON_INDEX THEN
      v_n_retorno   := v_nro_1;
      v_s_mensaje   := 'Llave Duplicada';
      p_c_datos     := fn_cnfg_ret_vacio;
      p_c_salida    :=
         fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno,
                              p_s_mensaje   => v_s_mensaje);
   WHEN OTHERS THEN
      v_n_retorno   := v_nro_1;
      v_s_mensaje   :=
         'MVNTO_CNFRG_GLBAL - '
         || SQLCODE
         || ' - '
         || SQLERRM
         || ' - '
         || DBMS_UTILITY.format_error_backtrace;
      p_c_datos     := fn_cnfg_ret_vacio;
      p_c_salida    :=
         fn_cnfg_ret_mensaje (p_n_retorno   => v_n_retorno,
                              p_s_mensaje   => v_s_mensaje);
END SP_CNFG_GRABA_MVNTO;