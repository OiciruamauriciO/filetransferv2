create or replace PROCEDURE BuscarColumnasEnBaseDeDatos (
    p_columnas IN VARCHAR2,
    o_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN o_cursor FOR
        SELECT column_name, table_name, owner
        FROM (
            SELECT TRIM(REGEXP_SUBSTR(p_columnas, '[^,]+', 1, LEVEL)) AS columna
            FROM dual
            CONNECT BY REGEXP_SUBSTR(p_columnas, '[^,]+', 1, LEVEL) IS NOT NULL
        ) col
        JOIN all_tab_columns t ON UPPER(t.column_name) = UPPER(col.columna);
END;