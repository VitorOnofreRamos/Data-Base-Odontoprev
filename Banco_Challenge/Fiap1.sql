-- Função com Cursor e Joins para Relatório Formatado.

set SERVEROUTPUT on;

CREATE OR REPLACE FUNCTION relatorio_Consultas_Dentista RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT d.Nome AS Dentista, c.Data_Consulta, p.Nome AS Paciente
        FROM Consulta c
        JOIN Dentista d ON c.ID_Dentista = d.ID_Dentista
        JOIN Paciente p ON c.ID_Paciente = p.ID_Paciente
        ORDER BY c.Data_Consulta DESC;
    
    RETURN v_cursor;
END relatorio_Consultas_Dentista;
/

--

CREATE OR REPLACE FUNCTION relatorio_Especialidade_Consultas RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT d.Especialidade, COUNT(c.ID_Consulta) AS Total_Consultas,
               AVG(EXTRACT(DAY FROM (c.Data_Consulta - SYSDATE))) AS Media_Dias
        FROM Dentista d
        INNER JOIN Consulta c ON d.ID_Dentista = c.ID_Dentista
        GROUP BY d.Especialidade
        ORDER BY Total_Consultas DESC;
    
    RETURN v_cursor;
END relatorio_Especialidade_Consultas;
/