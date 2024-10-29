-- Função com Cursor e Joins para Relatório Formatado.

CREATE OR REPLACE FUNCTION GerarRelatorioConsultas RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT d.Nome AS Dentista, d.Especialidade, 
               COUNT(c.ID_Consulta) AS Total_Consultas,
               AVG(EXTRACT(DAY FROM (c.Data_Consulta - SYSDATE))) AS Media_Dias_Ate_Consulta
        FROM Dentista d
        INNER JOIN Consulta c ON d.ID_Dentista = c.ID_Dentista
        GROUP BY d.Nome, d.Especialidade
        ORDER BY Total_Consultas DESC;

    RETURN v_cursor; -- Retorna o cursor
END GerarRelatorioConsultas;
/

--

CREATE OR REPLACE FUNCTION GerarRelatorioPacientes RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT p.Nome AS Paciente, p.CPF, 
               COUNT(c.ID_Consulta) AS Total_Consultas,
               MAX(c.Data_Consulta) AS Ultima_Consulta
        FROM Paciente p
        LEFT JOIN Consulta c ON p.ID_Paciente = c.ID_Paciente
        GROUP BY p.Nome, p.CPF
        ORDER BY Total_Consultas DESC, Ultima_Consulta DESC;

    RETURN v_cursor; -- Retorna o cursor
END GerarRelatorioPacientes;
/

--

SET SERVEROUTPUT ON;

DECLARE
    v_relatorio_consultas SYS_REFCURSOR;
    v_relatorio_pacientes SYS_REFCURSOR;
    v_dentista VARCHAR2(100);
    v_especialidade VARCHAR2(100);
    v_total_consultas NUMBER;
    v_media_dias_a_te_consulta NUMBER;

    v_paciente VARCHAR2(100);
    v_cpf VARCHAR2(14);
    v_total_consultas_paciente NUMBER;
    v_ultima_consulta TIMESTAMP;
BEGIN
    -- Chama a função que gera o relatório de consultas
    v_relatorio_consultas := GerarRelatorioConsultas();
    DBMS_OUTPUT.PUT_LINE('Relatório de Consultas por Dentista:');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');

    LOOP
        FETCH v_relatorio_consultas INTO v_dentista, v_especialidade, v_total_consultas, v_media_dias_a_te_consulta;
        EXIT WHEN v_relatorio_consultas%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Dentista: ' || v_dentista);
        DBMS_OUTPUT.PUT_LINE('Especialidade: ' || v_especialidade);
        DBMS_OUTPUT.PUT_LINE('Total de Consultas: ' || v_total_consultas);
        DBMS_OUTPUT.PUT_LINE('Média de Dias até a Consulta: ' || ROUND(v_media_dias_a_te_consulta, 2));
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;

    -- Chama a função que gera o relatório de pacientes
    v_relatorio_pacientes := GerarRelatorioPacientes();
    DBMS_OUTPUT.PUT_LINE('Relatório de Pacientes e suas Consultas:');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');

    LOOP
        FETCH v_relatorio_pacientes INTO v_paciente, v_cpf, v_total_consultas_paciente, v_ultima_consulta;
        EXIT WHEN v_relatorio_pacientes%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Paciente: ' || v_paciente);
        DBMS_OUTPUT.PUT_LINE('CPF: ' || v_cpf);
        DBMS_OUTPUT.PUT_LINE('Total de Consultas: ' || v_total_consultas_paciente);
        DBMS_OUTPUT.PUT_LINE('Última Consulta: ' || TO_CHAR(v_ultima_consulta, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;

    -- Fecha os cursores
    CLOSE v_relatorio_consultas;
    CLOSE v_relatorio_pacientes;
END;

