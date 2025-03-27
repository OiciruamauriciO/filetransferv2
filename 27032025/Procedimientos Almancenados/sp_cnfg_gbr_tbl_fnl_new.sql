create or replace PROCEDURE "SP_CNFG_GBR_TBL_FNL_NEW" (
    p_s_fecha  IN VARCHAR2,
    p_c_datos  OUT SYS_REFCURSOR,
    p_c_salida OUT SYS_REFCURSOR
) AS
    -- Variables
    v_d_fecha       NUMBER;
    v_n_retorno     NUMBER;
    v_s_mensaje     VARCHAR2(1000);

     ----------------------------------
    --EXCEPCIONES
    ----------------------------------
    E_FECHA_NULA EXCEPTION;
    E_FECHA_INVALIDA EXCEPTION;
    ----------------------------------
    --CONSTANTES
    ----------------------------------
    V_NRO_0 CONSTANT NUMBER := 0;
    V_NRO_1 CONSTANT NUMBER := 1;

    CURSOR cur_t IS
        SELECT
            cnfgs_in_contarcstglobalsan.utilizationidservicing AS utilizationid,
            cnfgs_in_stratus.entitydocumentid                  AS num_rut_clt,
            35                                                 AS num_end,
            1                                                  AS cod_suc_ope,
            cnfgs_in_invoice.invoicecodepk                     AS num_ope,
            cnfgs_in_contarcstglobalsan.utilizationversionid   AS num_seq,
            81                                                 AS cod_pto_ope,
            cnfgs_in_contarcstglobalsan.accsubproductid        AS cod_spo_ope,
            0                                                  AS num_rto,
            cnfgs_in_invoice.invoicecodepk                     AS num_itr_ope,
            0                                                  AS num_pgr,
            180                                                AS cod_pto_ext,
            278                                                AS num_suc_ctb,
            8                                                  AS cod_atv_dtn,
            0                                                  AS cod_tpo_cdt,
            1                                        AS cod_ecl_ope,
            1                                       AS cod_eta_ope,
            1                                        AS cod_ejv_ope
        FROM
                 cnfgs_in_contarcstglobalsan
            JOIN cnfgs_in_term ON cnfgs_in_term.utilizationidservicing = cnfgs_in_contarcstglobalsan.utilizationidservicing
            JOIN cnfgs_in_flow ON cnfgs_in_flow.utilizationidservicing = cnfgs_in_contarcstglobalsan.utilizationidservicing
            JOIN cnfgs_in_invoice ON cnfgs_in_invoice.utilizationidpk = cnfgs_in_contarcstglobalsan.utilizationidservicing
            JOIN cnfgs_in_participants ON cnfgs_in_participants.utilizationidservicing = cnfgs_in_contarcstglobalsan.utilizationidservicing
            JOIN cnfgs_in_stratus ON cnfgs_in_stratus.entityglcs = cnfgs_in_participants.counterparty
        WHERE
                upper(cnfgs_in_contarcstglobalsan.objecttype) = 'UTILIZATION'
            AND upper(cnfgs_in_flow.conceptsubtypename) = 'PRINCIPALPAYMENT'
            AND upper(cnfgs_in_participants.participantclassification) = 'BORROWER';


    TYPE t_oprcn_data IS TABLE OF cur_t%rowtype;
    l_oprcn_data    t_oprcn_data;

    error_index NUMBER;
    error_code NUMBER;

BEGIN
    -- Validación de la fecha
    IF p_s_fecha IS NULL OR trim(p_s_fecha) = '' THEN
        raise_application_error(-20001, 'Fecha vacía o nula.');
    END IF;

    IF NOT fn_cnfg_num_idf_reg(p_s_fecha_valida => p_s_fecha) THEN
        raise_application_error(-20002, 'Fecha en formato incorrecto.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('flag 1');

    -- Convertir la fecha a formato numérico
    v_d_fecha := fn_cnfg_num_ret_date(p_n_fecha => TO_DATE(p_s_fecha, 'YYYYMMDD'));

    -- Procesar los datos del cursor
    DBMS_OUTPUT.PUT_LINE('flag 2');
    OPEN cur_t;
    LOOP
        FETCH cur_t BULK COLLECT INTO l_oprcn_data LIMIT 1000;
        DBMS_OUTPUT.PUT_LINE('flag 3 entre al cursor');

        EXIT WHEN l_oprcn_data.COUNT = 0;

        -- Insertar los datos en lotes
        BEGIN
            
        
            FORALL indx IN l_oprcn_data.first..l_oprcn_data.last--1..l_oprcn_data.COUNT SAVE EXCEPTIONS
                INSERT INTO cnfgs_dt_oprcn (
                    num_ide_reg,
                    num_rut_clt,
                    num_end,
                    cod_suc_ope,
                    num_ope,
                    num_seq,
                    cod_pto_ope,
                    cod_spo_ope,
                    num_rto,
                    num_itr_ope,
                    num_pgr,
                    cod_pto_ext,
                    num_suc_ctb,
                    cod_atv_dtn,
                    cod_tpo_cdt,
                    cod_ecl_ope,
                    cod_eta_ope,
                    cod_ejv_ope
                ) VALUES (
                    v_d_fecha,
                    l_oprcn_data(indx).num_rut_clt,
                    l_oprcn_data(indx).num_end,
                    l_oprcn_data(indx).cod_suc_ope,
                    l_oprcn_data(indx).num_ope,
                    l_oprcn_data(indx).num_seq,
                    l_oprcn_data(indx).cod_pto_ope,
                    l_oprcn_data(indx).cod_spo_ope,
                    l_oprcn_data(indx).num_rto,
                    l_oprcn_data(indx).num_itr_ope,
                    l_oprcn_data(indx).num_pgr,
                    l_oprcn_data(indx).cod_pto_ext,
                    l_oprcn_data(indx).num_suc_ctb,
                    l_oprcn_data(indx).cod_atv_dtn,
                    l_oprcn_data(indx).cod_tpo_cdt,
                    l_oprcn_data(indx).cod_ecl_ope,
                    l_oprcn_data(indx).cod_eta_ope,
                    l_oprcn_data(indx).cod_ejv_ope
                );
                DBMS_OUTPUT.PUT_LINE('flag 4 despues de insertar');

        EXCEPTION
            WHEN OTHERS THEN
                -- Capturar excepciones individuales
                FOR j IN 1..SQL%BULK_EXCEPTIONS.COUNT LOOP
                    DBMS_OUTPUT.PUT_LINE('flag 5 cai en error');
                    error_index := SQL%BULK_EXCEPTIONS(j).ERROR_INDEX;
                    error_code := SQL%BULK_EXCEPTIONS(j).ERROR_CODE;
                    DBMS_OUTPUT.PUT_LINE('Error en índice ' || error_index || ': Código de error ' || error_code);
                END LOOP;
        END;
    END LOOP;

    CLOSE cur_t;

    -- Enviar los datos procesados como salida
    v_s_mensaje := 'OK';
    v_n_retorno := v_nro_0;
    p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
EXCEPTION
    WHEN e_fecha_nula THEN
        v_n_retorno := v_nro_1;
        v_s_mensaje := 'ERROR FECHA VACIA O NULA';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN e_fecha_invalida THEN
        v_n_retorno := v_nro_1;
        v_s_mensaje := 'ERROR FECHA FORMATO INCORRECTO';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN no_data_found THEN
        v_n_retorno := v_nro_1;
        v_s_mensaje := 'NO EXISTEN DATOS';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN dup_val_on_index THEN
        v_n_retorno := v_nro_1;
        v_s_mensaje := 'LLAVE DUPLICADA';
        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
    WHEN OTHERS THEN
        v_n_retorno := v_nro_1;
        v_s_mensaje := 'SP_CNFG_INTFZ_DEUDR - '
                       || sqlcode
                       || ' - '
                       || sqlerrm
                       || ' - '
                       || dbms_utility.format_error_backtrace;

        p_c_datos := fn_cnfg_ret_vacio;
        p_c_salida := fn_cnfg_ret_mensaje(p_n_retorno => v_n_retorno, p_s_mensaje => v_s_mensaje);
END sp_cnfg_gbr_tbl_fnl_new;