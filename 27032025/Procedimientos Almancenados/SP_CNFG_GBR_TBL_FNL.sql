create or replace PROCEDURE            "SP_CNFG_GBR_TBL_FNL"  (
    P_S_FECHA IN VARCHAR2,
    P_C_DATOS OUT SYS_REFCURSOR,
    P_C_SALIDA OUT SYS_REFCURSOR
) AS
    /*************************************************************************************************
     PROCEDIMIENTO   : SP_CNFG_GBR_TBL_FNL
     HU              : J00102-5933
     OBJETIVO        : SERVICIO DISEÑADO PARA MIGRAR DATOS DE VARIAS TABLAS TEMPORALES A SUS CORRESPONDIENTES
     TABLAS DEFINITIVAS EN LA BASE DE DATOS. RECIBE COMO PARÁMETROS DE ENTRADA LA FECHA CON LA CUAL SE GENERARA
     SU NUM_IDE_REG (IDENTIFICADOR) ANTES DE LA INSERCIÓN, REALIZA VALIDACIONES PARA ASEGURAR LA INTEGRIDAD DE LOS DATOS.

     SISTEMA         : CNFCG
     BASE DE DATOS   : CONFIG_GLOBAL_DBO
     TABLAS USADAS   :
     CNFGS_IN_CONTARCSTGLOBALSAN
     CNFGS_IN_FLOW
     CNFGS_IN_TERM
     CNFGS_IN_INVOICE
     CNFGS_IN_BANKS
     VISTAS MATERIALIZADAS:
     PEDT001
     PEDT084
     PEDT021
     FECHA           : 13-12-2024
     AUTOR           : JONATAN SOTO IMIO - CELULA INGENIO
     INPUT           : P_S_FECHA
     OUTPUT          : P_C_DATOS
     P_C_SALIDA

     OBSERVACIONES   : DADO QUE LAS CONSULTAS SELECT ACCEDEN A TABLAS TEMPORALES, EL PLAN DE EJECUCIÓN
     DEL OPTIMIZADOR DE CONSULTAS NO CONSIDERA LOS ÍNDICES.
     ESTO SE DEBE A QUE LAS TABLAS TEMPORALES, A MENUDO, NO TIENEN ÍNDICES.

     REVISIONES:
     VER        DATE        AUTHOR                DESCRIPTION
     ---------  ----------  -------------------   ------------------------------------
     M0         13-12-2024  JONATAN SOTO IMIO     VERSION INICIAL
     --************************************************************************************************/
    ----------------------------------
    --VARIABLES
    ----------------------------------
    V_D_FECHA NUMBER;
    V_N_RETORNO NUMBER;
    V_S_MENSAJE VARCHAR2(1000);
    V_N_CONTADOR_OPRCN NUMBER;
    V_N_CONTADOR_SALDO NUMBER;
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

BEGIN

        IF P_S_FECHA IS NULL
        OR TRIM(P_S_FECHA) = '' THEN RAISE E_FECHA_NULA;
        END IF;

        IF NOT FN_CNFG_NUM_IDF_REG(P_S_FECHA_VALIDA => P_S_FECHA) THEN RAISE E_FECHA_INVALIDA;
        END IF;

        V_D_FECHA := FN_CNFG_NUM_RET_DATE(P_N_FECHA => TO_DATE(P_S_FECHA, 'YYYYMMDD'));

        INSERT INTO
            CNFGS_DT_OPRCN (
                NUM_IDE_REG,
                NUM_RUT_CLT,
                NUM_END,
                COD_SUC_OPE,
                NUM_OPE,
                NUM_SEQ,
                COD_PTO_OPE,
                COD_SPO_OPE,
                NUM_RTO,
                NUM_ITR_OPE,
                NUM_PGR,
                COD_PTO_EXT,
                NUM_SUC_CTB,
                COD_ATV_DTN,
                COD_TPO_CDT,
                COD_ECL_OPE,
                COD_ETA_OPE,
                COD_EJV_OPE,
                FLG_CGO_AUT,
                NUM_CTA_CGO,
                FLG_DJD_OPE,
                FLG_SGD_OPE,
                FLG_SGR_CES,
                FLG_OTR_SGR,
                DSC_SIS_ORG,
                COD_BCO_ORG,
                FEC_CSE_OPE,
                FEC_OTD_OPE,
                FEC_RNV_OPE,
                FEC_TRM_OPE,
                FEC_PRM_VNO,
                FEC_PXM_VNO_CPL,
                FEC_PXM_VNO_INT,
                FEC_ISU_OPE,
                FEC_INT_PGO,
                FEC_ULT_PAG,
                FEC_TRS_CAG,
                FEC_ACR,
                FEC_VNO_OGL,
                IMP_ORG_OPE,
                IMP_RNV_OPE,
                COD_CUA_PAG,
                IMP_CUO,
                NUM_CUO_PAT,
                NUM_CUO_IPG,
                NUM_CUO_PAG,
                NUM_FCC_CUO_CPL,
                NUM_FCC_CUO_INT,
                NUM_PZO_PMD_OPE,
                NUM_PZO_PMD_RDL,
                IMP_PPN_OPE,
                COD_AMT_OPE,
                FLG_CLO_INT,
                COD_VRC_TSA,
                COD_ERS_TSA,
                FEC_CBO_TSA,
                FEC_PXM_CBO_TSA,
                POR_TSB_OPE,
                POR_TSS_OPE,
                POR_TSA_VGT,
                POR_TST_OPE,
                POR_TSA_EFT,
                COD_MON_OPE,
                COD_MON_OPE_CMF,
                COD_MON_CTB_CPL,
                COD_MON_CTB_INT,
                VAL_TPO_CBO_OPE,
                COD_OPE_RNE,
                POR_DSB_RNE,
                VAL_ATN_RNE,
                FLG_CNV_ALD,
                FEC_CCR_OPE,
                FLG_CDT_ADM,
                COD_CPC_FNR,
                COD_BLQ_TJT,
                NUM_TJT_ADC,
                IMP_DIP_LCD,
                IMP_DIP_LNA_SBG,
                NUM_REG_CUO,
                NUM_REG_RLD,
                POR_OPC_CMP,
                IMP_BNS,
                COD_CSR_OPE,
                FLG_RPB_OPE,
                NUM_RUT_RPB_OPE,
                POR_AVL,
                FLG_AFT_IVA,
                FLG_CDT_SRZ,
                IMP_EXD_LNA,
                IMP_LNA_DOS,
                IMP_DIP_LNA_DOS,
                COD_SUC_SLT,
                NUM_SLT,
                FLG_CDT_RFC,
                FEC_CAL_ATP,
                IMP_CAL_ATP_MNA,
                IMP_CAL_ATP_MOR,
                NUM_PZO_AMT,
                COD_PZO_AMT,
                NUM_DIA_MRA,
                IMP_CUO_INL,
                IMP_AMT_PCP_MNA,
                IMP_AMT_PCP_MOR,
                IMP_SDO_FAL_MNA,
                IMP_SDO_FAL_MOR,
                FLG_TPO_CZN,
                IMP_SDO_RVS_TSA,
                FLG_FLJ_CUO_IRG,
                FEC_CBO_CDC,
                FEC_IPG_VGT,
                POR_TSM,
                COD_TPO_TSA_EXS,
                POR_TSA_EXS,
                FEC_DBT,
                IMP_LMT_LCD,
                IMP_SDO_SAL_CAG_MNA,
                IMP_SDO_SAL_CAG_MOR,
                COD_TPO_ORG_FND,
                COD_TPO_FND,
                IMP_INT_DFD_MNA,
                IMP_INT_DFD_MOR,
                IMP_INT_DFD_PMD_MNA,
                IMP_INT_DFD_PMD_MOR,
                IMP_INT_CBR_MNA,
                IMP_INT_CBR_MOR,
                IMP_INT_EXS_MNA,
                IMP_INT_EXS_MOR,
                IMP_SDO_PRC_MNA,
                IMP_SDO_PRC_MOR,
                IMP_SDO_EXS_MNA,
                IMP_SDO_EXS_MOR,
                IMP_SPM_EXS_MNA,
                IMP_SPM_EXS_MOR,
                IMP_PMD_NDS_MNA,
                IMP_PMD_NDS_MOR,
                COD_STC_CTB,
                FLG_MNJ_INT,
                FLG_FRA_BLC,
                NUM_RRC,
                IMP_TC_MNA,
                IMP_TC_MOR,
                IMP_SDO_DSS_MNA,
                IMP_SDO_DSS_MOR,
                IMP_PMD_PND_AMT_MOR,
                IMP_PMD_RRC_MOR,
                IMP_SDO_TRU_MNA,
                IMP_SDO_TMD_MNA,
                IMP_SDO_TR3_MNA,
                IMP_SDO_TR4_MNA,
                IMP_SDO_TR5_MNA,
                FLG_ACV_CGT,
                NUM_FCC_RRC,
                FLG_ISU,
                FLG_MTD_DVG,
                COD_MCR_CBT_CPR,
                COD_TCT,
                COD_TPO_INM,
                COD_MRC_ESR,
                FLG_SNB,
                FLG_SNB_CPR,
                FLG_TPO_INV,
                FLG_TPO_ETG,
                FLG_ITZ_DDA,
                COD_EST_REG
            )
        SELECT
            DISTINCT V_D_FECHA AS NUM_IDE_REG,
            CNFGS_IN_STRATUS.ENTITYDOCUMENTID AS NUM_RUT_CLT,
            35 AS NUM_END,
            T3.PENUMSUC AS COD_SUC_OPE,
            CNFGS_IN_INVOICE.INVOICECODEPK AS NUM_OPE,
            CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONVERSIONID AS NUM_SEQ,
            CNFGS_IN_CONTARCSTGLOBALSAN.ACCPRODUCTID AS COD_PTO_OPE,
            CNFGS_IN_CONTARCSTGLOBALSAN.ACCSUBPRODUCTID AS COD_SPO_OPE,
            0 AS NUM_RTO,
            CNFGS_IN_INVOICE.INVOICECODEPK AS NUM_ITR_OPE,
            0 AS NUM_PGR,
            180 AS COD_PTO_EXT,
            278 AS NUM_SUC_CTB,
            8 AS COD_ATV_DTN,
            0 AS COD_TPO_CDT,
            T2.PENUMPUE AS COD_ECL_OPE,
            T2.PENUMPUE AS COD_ETA_OPE,
            T2.PENUMPUE AS COD_EJV_OPE,
            CASE
                WHEN CNFGS_IN_BANKS.BANKACCOUNT IS NOT NULL THEN 1
                ELSE 0
            END AS FLG_CGO_AUT,
            CNFGS_IN_BANKS.BANKACCOUNT AS NUM_CTA_CGO,
            'N' AS FLG_DJD_OPE,
            'N' AS FLG_SGD_OPE,
            'N' AS FLG_SGR_CES,
            'N' AS FLG_OTR_SGR,
            'FAC' AS DSC_SIS_ORG,
            0 AS COD_BCO_ORG,
            CNFGS_IN_CONTARCSTGLOBALSAN.VALUEDATE AS FEC_CSE_OPE,
            CNFGS_IN_CONTARCSTGLOBALSAN.VALUEDATE AS FEC_OTD_OPE,
            CNFGS_IN_CONTARCSTGLOBALSAN.VALUEDATE AS FEC_RNV_OPE,
            CNFGS_IN_FLOW.EFFECTIVEPAYMENTDATE AS FEC_TRM_OPE,
            CNFGS_IN_FLOW.EFFECTIVEPAYMENTDATE AS FEC_PRM_VNO,
            CNFGS_IN_FLOW.EFFECTIVEPAYMENTDATE AS FEC_PXM_VNO_CPL,
            CNFGS_IN_FLOW.EFFECTIVEPAYMENTDATE AS FEC_PXM_VNO_INT,
            CNFGS_IN_CONTARCSTGLOBALSAN.VALUEDATE AS FEC_ISU_OPE,
            CNFGS_IN_FLOW.EFFECTIVEPAYMENTDATE AS FEC_INT_PGO,
            CNFGS_IN_FLOW.EFFECTIVEPAYMENTDATE AS FEC_ULT_PAG,
            CASE
                WHEN (
                    SYSDATE > CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    AND CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONSTATUS = 'LIVE'
                ) THEN ADD_MONTHS(CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE, 36)
            END AS FEC_TRS_CAG,
            CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE AS FEC_ACR,
            CNFGS_IN_INVOICE.DUEDATE AS FEC_VNO_OGL,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANLIVEAMOUNT AS IMP_ORG_OPE,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANLIVEAMOUNT AS IMP_RNV_OPE,
            0 AS COD_CUA_PAG,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANLIVEAMOUNT AS IMP_CUO,
            1 AS NUM_CUO_PAT,
            CASE
                WHEN (
                    SYSDATE > CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    AND CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONSTATUS = 'LIVE'
                ) THEN 1
                ELSE 0
            END AS NUM_CUO_IPG,
            0 AS NUM_CUO_PAG,
            0 AS NUM_FCC_CUO_CPL,
            0 AS NUM_FCC_CUO_INT,
            0 AS NUM_PZO_PMD_OPE,
            CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE - CNFGS_IN_CONTARCSTGLOBALSAN.VALUEDATE AS NUM_PZO_PMD_RDL,
            0 AS IMP_PPN_OPE,
            0 AS COD_AMT_OPE,
            '0' AS FLG_CLO_INT,
            0 AS COD_VRC_TSA,
            'M' AS COD_ERS_TSA,
            NULL AS FEC_CBO_TSA,
            NULL AS FEC_PXM_CBO_TSA,
            0 AS POR_TSB_OPE,
            CNFGS_IN_TERM.SPREADRATE AS POR_TSS_OPE,
            CNFGS_IN_TERM.RATE AS POR_TSA_VGT,
            CASE
                WHEN CNFGS_IN_TERM.FIXEDRATE <> 0 THEN CNFGS_IN_TERM.RATE -(CNFGS_IN_TERM.FIXEDRATE)
                ELSE CNFGS_IN_TERM.RATE -(CNFGS_IN_TERM.SPREADRATE)
            END AS POR_TST_OPE,
            CNFGS_IN_TERM.RATE AS POR_TSA_EFT,
            CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE AS COD_MON_OPE,
            CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE AS COD_MON_OPE_CMF,
            CASE
                WHEN CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE = 'CLP' THEN 'CHN'
                WHEN CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE = 'USD' THEN 'EXT'
            END AS COD_MON_CTB_CPL,
            CASE
                WHEN CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE = 'CLP' THEN 'CHN'
                WHEN CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE = 'USD' THEN 'EXT'
            END AS COD_MON_CTB_INT,
            1 AS VAL_TPO_CBO_OPE,
            'N' AS COD_OPE_RNE,
            0 AS POR_DSB_RNE,
            0 AS VAL_ATN_RNE,
            'N' AS FLG_CNV_ALD,
            NULL AS FEC_CCR_OPE,
            'N' AS FLG_CDT_ADM,
            0 AS COD_CPC_FNR,
            0 AS COD_BLQ_TJT,
            0 AS NUM_TJT_ADC,
            0 AS IMP_DIP_LCD,
            1 AS IMP_DIP_LNA_SBG,
            1 AS NUM_REG_CUO,
            0 AS NUM_REG_RLD,
            0 AS POR_OPC_CMP,
            0 AS IMP_BNS,
            '  ' AS COD_CSR_OPE, --2 espacios
            'S' AS FLG_RPB_OPE,
            CNFGS_IN_STRATUS.ENTITYDOCUMENTID AS NUM_RUT_RPB_OPE,
            0 AS POR_AVL,
            'N' AS FLG_AFT_IVA,
            'N' AS FLG_CDT_SRZ,
            0 AS IMP_EXD_LNA,
            0 AS IMP_LNA_DOS,
            0 AS IMP_DIP_LNA_DOS,
            T.PESUCADM AS COD_SUC_SLT,
            0 AS NUM_SLT,
            'N' AS FLG_CDT_RFC,
            CNFGS_IN_FLOW.EFFECTIVEPAYMENTDATE AS FEC_CAL_ATP,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANUSEDAMOUNT AS IMP_CAL_ATP_MNA,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANUSEDAMOUNT AS IMP_CAL_ATP_MOR,
            (CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE - CNFGS_IN_CONTARCSTGLOBALSAN.VALUEDATE) AS NUM_PZO_AMT,
            'D' AS COD_PZO_AMT,
            (TRUNC(SYSDATE) - CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE) AS NUM_DIA_MRA,
            0 AS IMP_CUO_INL,
            0 AS IMP_AMT_PCP_MNA,
            0 AS IMP_AMT_PCP_MOR,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANIRREGULARAMOUNT AS IMP_SDO_FAL_MNA,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANIRREGULARAMOUNT AS IMP_SDO_FAL_MOR,
            'L' AS FLG_TPO_CZN,
            0 AS IMP_SDO_RVS_TSA,
            'N' AS FLG_FLJ_CUO_IRG,
            NULL AS FEC_CBO_CDC,
            NULL AS FEC_IPG_VGT,
            0 AS POR_TSM,
            0 AS COD_TPO_TSA_EXS,
            0 AS POR_TSA_EXS,
            NULL AS FEC_DBT,
            0 AS IMP_LMT_LCD,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANIRREGULARAMOUNT AS IMP_SDO_SAL_CAG_MNA,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANIRREGULARAMOUNT AS IMP_SDO_SAL_CAG_MOR,
            ' ' AS COD_TPO_ORG_FND, --1 espacio
            0 AS COD_TPO_FND,
            0 AS IMP_INT_DFD_MNA,
            0 AS IMP_INT_DFD_MOR,
            0 AS IMP_INT_DFD_PMD_MNA,
            0 AS IMP_INT_DFD_PMD_MOR,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANTOTALINTEREST AS IMP_INT_CBR_MNA,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANTOTALINTEREST AS IMP_INT_CBR_MOR,
            0 AS IMP_INT_EXS_MNA,
            0 AS IMP_INT_EXS_MOR,
            0 AS IMP_SDO_PRC_MNA,
            0 AS IMP_SDO_PRC_MOR,
            0 AS IMP_SDO_EXS_MNA,
            0 AS IMP_SDO_EXS_MOR,
            0 AS IMP_SPM_EXS_MNA,
            0 AS IMP_SPM_EXS_MOR,
            0 AS IMP_PMD_NDS_MNA,
            0 AS IMP_PMD_NDS_MOR,
            0 AS COD_STC_CTB,
            CASE
                WHEN CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE = 'CLP' THEN 'S'
                WHEN CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE = 'USD' THEN 'N'
            END AS FLG_MNJ_INT,
            'N' AS FLG_FRA_BLC,
            0 AS NUM_RRC,
            (CNFGS_IN_CONTARCSTGLOBALSAN.SANUSEDAMOUNT + CNFGS_IN_CONTARCSTGLOBALSAN.SANTOTALINTEREST + CNFGS_IN_CONTARCSTGLOBALSAN.SANTOTALFINANCIALFEES)
            AS IMP_TC_MNA,
            CNFGS_IN_CONTARCSTGLOBALSAN.SANUSEDAMOUNT + CNFGS_IN_CONTARCSTGLOBALSAN.SANTOTALINTEREST + CNFGS_IN_CONTARCSTGLOBALSAN.SANTOTALFINANCIALFEES
            AS IMP_TC_MOR,
            0 AS IMP_SDO_DSS_MNA,
            0 AS IMP_SDO_DSS_MOR,
            0 AS IMP_PMD_PND_AMT_MOR,
            0 AS IMP_PMD_RRC_MOR,
            CASE
                WHEN CNFGS_IN_FLOW.IRREGULARFLAG = 1
                AND (
                    (
                        SYSDATE - CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    ) > 1
                    AND (
                        SYSDATE - CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    ) <= 15
                ) THEN CNFGS_IN_CONTARCSTGLOBALSAN.SANLIVEAMOUNT
            END AS IMP_SDO_TRU_MNA,
            CASE
                WHEN CNFGS_IN_FLOW.IRREGULARFLAG = 1
                AND (
                    (
                        SYSDATE - CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    ) > 16
                    AND (
                        SYSDATE - CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    ) <= 29
                ) THEN CNFGS_IN_CONTARCSTGLOBALSAN.SANLIVEAMOUNT
                ELSE 0
            END AS IMP_SDO_TMD_MNA,
            CASE
                WHEN CNFGS_IN_FLOW.IRREGULARFLAG = 1
                AND (
                    (
                        SYSDATE - CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    ) > 30
                    AND (
                        SYSDATE - CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    ) <= 59
                ) THEN CNFGS_IN_CONTARCSTGLOBALSAN.SANLIVEAMOUNT
            END AS IMP_SDO_TR3_MNA,
            CASE
                WHEN CNFGS_IN_FLOW.IRREGULARFLAG = 1
                AND (
                    (
                        SYSDATE - CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    ) > 60
                    AND (
                        SYSDATE - CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    ) <= 89
                ) THEN CNFGS_IN_CONTARCSTGLOBALSAN.SANLIVEAMOUNT
            END AS IMP_SDO_TR4_MNA,
            CASE
                WHEN CNFGS_IN_FLOW.IRREGULARFLAG = 1
                AND (
                    (
                        SYSDATE - CNFGS_IN_CONTARCSTGLOBALSAN.MATURITYDATE
                    ) > 90
                ) THEN CNFGS_IN_CONTARCSTGLOBALSAN.SANLIVEAMOUNT
            END AS IMP_SDO_TR5_MNA,
            0 AS FLG_ACV_CGT,
            0 AS NUM_FCC_RRC,
            0 AS FLG_ISU,
            0 AS FLG_MTD_DVG,
            0 AS COD_MCR_CBT_CPR,
            0 AS COD_TCT,
            0 AS COD_TPO_INM,
            0 AS COD_MRC_ESR,
            0 AS FLG_SNB,
            0 AS FLG_SNB_CPR,
            0 AS FLG_TPO_INV,
            0 AS FLG_TPO_ETG,
            0 AS FLG_ITZ_DDA,
            0 AS COD_EST_REG
        FROM
            CNFGS_IN_CONTARCSTGLOBALSAN
            JOIN CNFGS_IN_TERM ON CNFGS_IN_TERM.UTILIZATIONIDSERVICING = CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONIDSERVICING
            JOIN CNFGS_IN_FLOW ON CNFGS_IN_FLOW.UTILIZATIONIDSERVICING = CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONIDSERVICING
            JOIN CNFGS_IN_INVOICE ON CNFGS_IN_INVOICE.UTILIZATIONIDPK = CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONIDSERVICING
            JOIN CNFGS_IN_PARTICIPANTS ON CNFGS_IN_PARTICIPANTS.UTILIZATIONIDSERVICING = CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONIDSERVICING
            JOIN CNFGS_IN_STRATUS ON CNFGS_IN_STRATUS.ENTITYGLCS = CNFGS_IN_PARTICIPANTS.COUNTERPARTY
            JOIN CNFGS_IN_BANKS ON CNFGS_IN_BANKS.BANKPK = CNFGS_IN_INVOICE.PROVIDERBANKFK
            JOIN PEDT001 T ON T.PENUMDOC = FN_CNFG_LPAD(
                P_S_CADENA => REPLACE(CNFGS_IN_STRATUS.ENTITYDOCUMENTID, '-', ''),
                P_N_LENGTH => 11,
                P_S_CHAR => 0
            )
            JOIN PEDT084 T2 ON T.PENUMPER = T2.PENUMPER
            JOIN PEDT021 T3 ON (
                T2.PENUMPUE = T3.PENUMPUE
                AND T2.PECDGENT = T3.PECDGENT
                AND 'TIT' = T2.PERELOFI
                AND '0035' = T2.PECDGENT
            )
        WHERE
            UPPER(CNFGS_IN_CONTARCSTGLOBALSAN.OBJECTTYPE) = 'UTILIZATION'
            AND UPPER(CNFGS_IN_FLOW.OBJECTTYPE) = 'UTILIZATION'
            AND UPPER(CNFGS_IN_FLOW.CONCEPTSUBTYPENAME) = 'PRINCIPALPAYMENT'
            AND UPPER(CNFGS_IN_TERM.OBJECTTYPE) = 'UTILIZATION'
            AND UPPER(CNFGS_IN_PARTICIPANTS.PARTICIPANTTYPE) = 'BORROWER'
            AND UPPER(CNFGS_IN_PARTICIPANTS.OBJECTTYPE) = 'UTILIZATION'
            AND UPPER(CNFGS_IN_PARTICIPANTS.PARTICIPANTCLASSIFICATION) = 'BORROWER';

        V_N_CONTADOR_OPRCN := SQL%ROWCOUNT;

        INSERT INTO
            CNFGS_DT_SALDO (
                NUM_IDE_REG,
                NUM_RUT_CLT,
                NUM_END,
                COD_SUC_OPE,
                NUM_OPE,
                NUM_SEQ,
                NUM_CUO,
                COD_PTO_OPE,
                COD_SPO_OPE,
                NUM_RTO,
                FEC_VNO_CUO,
                COD_CP,
                COD_EST_CUO,
                FEC_EST_CUO,
                IMP_PRD_CUO,
                IMP_CPL_MOR,
                IMP_INT_MOR,
                NUM_CCB_CPL,
                IMP_SDO_CPL,
                NUM_CCB_INT,
                IMP_SDO_INT,
                NUM_CCB_ISU,
                IMP_SDO_ISU,
                NUM_CCB_REJ,
                IMP_SDO_REJ
            )
        WITH FLOW_DATA AS (
        SELECT
                TBL_FLOW.UTILIZATIONIDSERVICING AS UTILIZATIONIDSERVICING,
                MAX(TBL_FLOW.EFFECTIVEPAYMENTDATE) AS EFFECTIVEPAYMENTDATE,
                MAX(
                    CASE
                        WHEN UPPER(TBL_FLOW.CONCEPTSUBTYPENAME) = 'PRINCIPALPAYMENT'
                        OR UPPER(TBL_FLOW.CONCEPTSUBTYPENAME) = 'EXPECTEDPAYMENTDATE' THEN TBL_FLOW.EXPECTEDPAYMENTDATE
                        ELSE NULL
                    END
                ) AS EXPECTEDPAYMENTDATE,
                SUM(
                    CASE
                        WHEN UPPER(TBL_FLOW.CONCEPTSUBTYPENAME) IN(
                            'PRINCIPALPAYMENT',
                            'GROUPDEBITFEE',
                            'PAYMENTSERVICINGFEE'
                        ) THEN TBL_FLOW.SANAMOUNT
                        ELSE 0
                    END
                ) AS IMP_CPL_MOR,
                SUM(
                    CASE
                        WHEN UPPER(TBL_FLOW.CONCEPTSUBTYPENAME) IN('LATEPAYMENTINTERESTS', 'SPLITPAYMENTINTERESTS') THEN TBL_FLOW.SANAMOUNT
                        ELSE 0
                    END
                ) AS IMP_INT_MOR,
                SUM(
                    CASE
                        WHEN UPPER(TBL_FLOW.CONCEPTSUBTYPENAME) IN(
                            'PRINCIPALPAYMENT',
                            'GROUPDEBITFEE',
                            'PAYMENTSERVICINGFEE'
                        ) THEN TBL_FLOW.SANAMOUNT
                        ELSE 0
                    END
                ) AS IMP_SDO_CPL,
                SUM(
                    CASE
                        WHEN UPPER(TBL_FLOW.CONCEPTSUBTYPENAME) IN('LATEPAYMENTINTERESTS', 'SPLITPAYMENTINTERESTS') THEN TBL_FLOW.SANAMOUNT
                        ELSE 0
                    END
                ) AS IMP_SDO_INT
            FROM
                CNFGS_IN_FLOW TBL_FLOW
            WHERE
                UPPER(TBL_FLOW.OBJECTTYPE) = 'UTILIZATION'
            GROUP BY
                TBL_FLOW.UTILIZATIONIDSERVICING
        )
        SELECT
            DISTINCT V_D_FECHA AS NUM_IDE_REG,
            CNFGS_IN_STRATUS.ENTITYDOCUMENTID AS NUM_RUT_CLT,
            35 AS NUM_END,
            T3.PENUMSUC AS COD_SUC_OPE,
            CNFGS_IN_INVOICE.INVOICECODEPK AS NUM_OPE,
            CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONVERSIONID AS NUM_SEQ,
            1 AS NUM_CUO,
            81 AS COD_PTO_OPE,
            CNFGS_IN_CONTARCSTGLOBALSAN.ACCSUBPRODUCTID AS COD_SPO_OPE,
            0 AS NUM_RTO,
            FLOW_DATA.EFFECTIVEPAYMENTDATE AS FEC_VNO_CUO,
            'COLOC' AS COD_CP,
            FN_CNFG_BSR_COD_PGO(
                FLOW_DATA.EXPECTEDPAYMENTDATE,
                CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONSTATUS
            ) AS COD_EST_CUO,
            FLOW_DATA.EFFECTIVEPAYMENTDATE AS FEC_EST_CUO,
            1 AS IMP_PRD_CUO,
            FLOW_DATA.IMP_CPL_MOR AS IMP_CPL_MOR,
            FLOW_DATA.IMP_INT_MOR AS IMP_INT_MOR,
            CASE
                WHEN CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE = 'CLP' THEN
                FN_CNFG_RET_NUM_CTA(P_N_PARAM_1 => 2, P_N_PARAM_2 => 1)
                WHEN CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE = 'USD' THEN
                FN_CNFG_RET_NUM_CTA(P_N_PARAM_1 => 2, P_N_PARAM_2 => 3)
            END AS NUM_CCB_CPL,
            FLOW_DATA.IMP_SDO_CPL AS IMP_SDO_CPL,
            0 AS NUM_CCB_INT, -- global no hay intereses contables
            0 AS IMP_SDO_INT, -- global no hay intereses contables
            0 AS NUM_CCB_ISU,
            0 AS IMP_SDO_ISU,
            CASE
                WHEN CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE = 'CLP' THEN
                FN_CNFG_RET_NUM_CTA(P_N_PARAM_1 => 2, P_N_PARAM_2 => 2)
                WHEN CNFGS_IN_CONTARCSTGLOBALSAN.REFERENCECURRENCYBASE = 'USD' THEN
                FN_CNFG_RET_NUM_CTA(P_N_PARAM_1 => 2, P_N_PARAM_2 => 4)
            END AS NUM_CCB_REJ,
            CNFGS_IN_FEEDETAILSGGLOBAL.ACCRUEDFEE AS IMP_SDO_REJ
        FROM
            CNFGS_IN_CONTARCSTGLOBALSAN
            JOIN CNFGS_IN_TERM ON CNFGS_IN_TERM.UTILIZATIONIDSERVICING = CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONIDSERVICING
            JOIN CNFGS_IN_INVOICE ON CNFGS_IN_INVOICE.UTILIZATIONIDPK = CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONIDSERVICING
            JOIN CNFGS_IN_PARTICIPANTS ON CNFGS_IN_PARTICIPANTS.UTILIZATIONIDSERVICING = CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONIDSERVICING
            JOIN CNFGS_IN_FEEDETAILSGGLOBAL ON CNFGS_IN_FEEDETAILSGGLOBAL.UTILIZATIONIDSERVICING = CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONIDSERVICING
            JOIN CNFGS_IN_STRATUS ON CNFGS_IN_STRATUS.ENTITYGLCS = CNFGS_IN_PARTICIPANTS.COUNTERPARTY
            JOIN CNFGS_IN_BANKS ON CNFGS_IN_BANKS.BANKPK = CNFGS_IN_INVOICE.PROVIDERBANKFK
            JOIN PEDT001 T ON T.PENUMDOC = FN_CNFG_LPAD(
                P_S_CADENA => REPLACE(CNFGS_IN_STRATUS.ENTITYDOCUMENTID, '-', ''),
                P_N_LENGTH => 11,
                P_S_CHAR => 0
            )
            JOIN PEDT084 T2 ON T.PENUMPER = T2.PENUMPER
            JOIN PEDT021 T3 ON (
                T2.PENUMPUE = T3.PENUMPUE
                AND T2.PECDGENT = T3.PECDGENT
                AND 'TIT' = T2.PERELOFI
                AND '0035' = T2.PECDGENT
            )
            JOIN FLOW_DATA ON FLOW_DATA.UTILIZATIONIDSERVICING = CNFGS_IN_CONTARCSTGLOBALSAN.UTILIZATIONIDSERVICING
        WHERE
            UPPER(CNFGS_IN_CONTARCSTGLOBALSAN.OBJECTTYPE) = 'UTILIZATION'
            AND UPPER(CNFGS_IN_TERM.OBJECTTYPE) = 'UTILIZATION'
            AND UPPER(CNFGS_IN_PARTICIPANTS.PARTICIPANTTYPE) = 'BORROWER'
            AND UPPER(CNFGS_IN_PARTICIPANTS.OBJECTTYPE) = 'UTILIZATION'
            AND UPPER(CNFGS_IN_PARTICIPANTS.PARTICIPANTCLASSIFICATION) = 'BORROWER';

        V_N_CONTADOR_SALDO := SQL%ROWCOUNT;

        OPEN P_C_DATOS FOR
        SELECT
            1 AS CONTROL,
            'CNFGS_DT_OPRCN' AS TABLE_NAME,
            V_N_CONTADOR_OPRCN AS ROW_COUNT
        FROM
            DUAL
        UNION ALL
        SELECT
            1 AS CONTROL,
            'CNFGS_DT_SALDO' AS TABLE_NAME,
            V_N_CONTADOR_SALDO AS ROW_COUNT
        FROM
            DUAL
        ORDER BY
            CONTROL DESC;

        V_S_MENSAJE := 'OK';
        V_N_RETORNO := V_NRO_0;
        P_C_SALIDA := FN_CNFG_RET_MENSAJE(P_N_RETORNO => V_N_RETORNO, P_S_MENSAJE => V_S_MENSAJE);

EXCEPTION
    WHEN E_FECHA_NULA THEN
        V_N_RETORNO := V_NRO_1;
        V_S_MENSAJE := 'ERROR FECHA VACIA O NULA';
        P_C_DATOS := FN_CNFG_RET_VACIO;
        P_C_SALIDA := FN_CNFG_RET_MENSAJE(P_N_RETORNO => V_N_RETORNO, P_S_MENSAJE => V_S_MENSAJE);
    WHEN E_FECHA_INVALIDA THEN
        V_N_RETORNO := V_NRO_1;
        V_S_MENSAJE := 'ERROR FECHA FORMATO INCORRECTO';
        P_C_DATOS := FN_CNFG_RET_VACIO;
        P_C_SALIDA := FN_CNFG_RET_MENSAJE(P_N_RETORNO => V_N_RETORNO, P_S_MENSAJE => V_S_MENSAJE);
    WHEN NO_DATA_FOUND THEN
        V_N_RETORNO := V_NRO_1;
        V_S_MENSAJE := 'NO EXISTEN DATOS';
        P_C_DATOS := FN_CNFG_RET_VACIO;
        P_C_SALIDA := FN_CNFG_RET_MENSAJE(P_N_RETORNO => V_N_RETORNO, P_S_MENSAJE => V_S_MENSAJE);
    WHEN DUP_VAL_ON_INDEX THEN
            V_N_RETORNO := V_NRO_1;
            V_S_MENSAJE := 'LLAVE DUPLICADA';
            P_C_DATOS := FN_CNFG_RET_VACIO;
            P_C_SALIDA := FN_CNFG_RET_MENSAJE(P_N_RETORNO => V_N_RETORNO, P_S_MENSAJE => V_S_MENSAJE);
    WHEN OTHERS THEN
            V_N_RETORNO := V_NRO_1;
            V_S_MENSAJE := 'SP_CNFG_INTFZ_DEUDR - '
                           || SQLCODE
                           || ' - '
                           || SQLERRM
                           || ' - '
                           || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            P_C_DATOS := FN_CNFG_RET_VACIO;
            P_C_SALIDA := FN_CNFG_RET_MENSAJE(P_N_RETORNO => V_N_RETORNO, P_S_MENSAJE => V_S_MENSAJE);
END SP_CNFG_GBR_TBL_FNL;