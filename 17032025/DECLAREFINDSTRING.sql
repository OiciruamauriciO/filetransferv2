DECLARE
    -- Lista de cadenas a buscar
    TYPE string_list IS TABLE OF VARCHAR2(100);
    search_strings string_list := string_list('cadena1', 'cadena2', 'cadena3');
    
    -- Texto objetivo donde buscaremos
    target_text VARCHAR2(4000) := 'Este es un ejemplo de texto. 
                                   Aquí está la cadena1 que se debe encontrar.
                                   Otro ejemplo donde aparece cadena2.
                                   Y también tenemos la cadena3 aquí.';
    
    -- Variables para recorrer las líneas
    line VARCHAR2(4000);
    line_number NUMBER := 1;
    found BOOLEAN := FALSE;
    
BEGIN
    -- Convertir el texto objetivo en un conjunto de líneas (por ejemplo, usando un salto de línea como delimitador)
    FOR i IN 1..search_strings.COUNT LOOP
        FOR line IN (SELECT REGEXP_SUBSTR(target_text, '[^' || CHR(10) || ']+', 1, LEVEL) AS line
                     FROM dual
                     CONNECT BY REGEXP_SUBSTR(target_text, '[^' || CHR(10) || ']+', 1, LEVEL) IS NOT NULL) LOOP
            -- Buscar la cadena en la línea
            IF INSTR(line.line, search_strings(i)) > 0 THEN
                -- Si se encuentra la cadena, imprimir el número de línea y el contenido
                DBMS_OUTPUT.PUT_LINE('Cadena encontrada: ' || search_strings(i));
                DBMS_OUTPUT.PUT_LINE('Línea ' || line_number || ': ' || line.line);
                found := TRUE;
            END IF;
            line_number := line_number + 1;
        END LOOP;
        IF NOT found THEN
            DBMS_OUTPUT.PUT_LINE('No se encontró la cadena: ' || search_strings(i));
        END IF;
    END LOOP;
END;
/
