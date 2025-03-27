create or replace FUNCTION FN_CNFG_MON_FMT (
    p_n_importe    IN NUMBER,    -- Importe a procesar
    p_n_enteros    IN NUMBER,    -- Número de dígitos enteros requeridos
    p_n_decimales  IN NUMBER     -- Número de dígitos decimales requeridos
) RETURN VARCHAR2 IS
    /*************************************************************************************************
    Procedimiento: FN_CNFG_MON_FMT
    HU           : J00102-5937
    Objetivo     : Este servicio redondea y formatea un monto específico según los enteros y decimales especificados.
                   Devuelve el resultado como una cadena formateada con ceros a la izquierda y decimales completos.

    Sistema      : CNFCG
    Base de Datos: CONFIG_GLOBAL_DBO
    Tablas Usadas: *
    Fecha        : 18-12-2024
    Autor        : Jonatan Soto - Celula Ingenio
    Input:
                   - p_n_importe: Número a procesar
                   - p_n_enteros: Cantidad de enteros requeridos
                   - p_n_decimales: Cantidad de decimales requeridos
    Output:
                   - VARCHAR2 con el número formateado
    *************************************************************************************************/
    v_s_importe_formato VARCHAR2(50); -- Resultado formateado con decimales
    v_s_sin_punto       VARCHAR2(50); -- Importe sin punto decimal
    v_n_longitud        NUMBER;       -- Longitud total requerida
BEGIN
    -- Calcular la longitud total requerida
    v_n_longitud := p_n_enteros + p_n_decimales;

    -- Redondear el importe al número de decimales especificado y convertirlo en una cadena
    v_s_importe_formato := TO_CHAR(ROUND(p_n_importe, p_n_decimales), 'FM999999999999999.0000000000');

    -- Eliminar el punto decimal de la cadena
    v_s_sin_punto := REPLACE(v_s_importe_formato, '.', '');

    -- Completar con ceros a la izquierda hasta alcanzar la longitud total requerida
    RETURN LPAD(v_s_sin_punto, v_n_longitud, '0');

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR FN_CNFG_MON_FMT - '
                                        || SQLCODE
                                        || ' - ERROR - '
                                        || SQLERRM);
END FN_CNFG_MON_FMT;