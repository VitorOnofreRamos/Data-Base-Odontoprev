set SERVEROUT ON;

DECLARE
    v_total_consultas NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Relatório de Consultas por Dentista (INNER JOIN):');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');

    FOR rec IN (
        SELECT d.Nome AS Dentista, d.Especialidade, 
               COUNT(c.ID_Consulta) AS Total_Consultas,
               AVG(EXTRACT(DAY FROM (c.Data_Consulta - SYSDATE))) AS Media_Dias_Ate_Consulta
        FROM Dentista d
        INNER JOIN Consulta c ON d.ID_Dentista = c.ID_Dentista
        GROUP BY d.Nome, d.Especialidade
        ORDER BY Total_Consultas DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Dentista: ' || rec.Dentista);
        DBMS_OUTPUT.PUT_LINE('Especialidade: ' || rec.Especialidade);
        DBMS_OUTPUT.PUT_LINE('Total de Consultas: ' || rec.Total_Consultas);
        DBMS_OUTPUT.PUT_LINE('Média de Dias até a Consulta: ' || ROUND(rec.Media_Dias_Ate_Consulta, 2));
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;

    SELECT COUNT(*) INTO v_total_consultas FROM Consulta;
    DBMS_OUTPUT.PUT_LINE('Total Geral de Consultas: ' || v_total_consultas);
END;
/


DECLARE
    v_total_pacientes NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Relatório de Pacientes e suas Consultas (LEFT JOIN):');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');

    FOR rec IN (
        SELECT p.Nome AS Paciente, p.CPF, 
               COUNT(c.ID_Consulta) AS Total_Consultas,
               MAX(c.Data_Consulta) AS Ultima_Consulta
        FROM Paciente p
        LEFT JOIN Consulta c ON p.ID_Paciente = c.ID_Paciente
        GROUP BY p.Nome, p.CPF
        ORDER BY Total_Consultas DESC, Ultima_Consulta DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Paciente: ' || rec.Paciente);
        DBMS_OUTPUT.PUT_LINE('CPF: ' || rec.CPF);
        DBMS_OUTPUT.PUT_LINE('Total de Consultas: ' || rec.Total_Consultas);
        DBMS_OUTPUT.PUT_LINE('Última Consulta: ' || TO_CHAR(rec.Ultima_Consulta, 'DD/MM/YYYY'));
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;

    SELECT COUNT(*) INTO v_total_pacientes FROM Paciente;
    DBMS_OUTPUT.PUT_LINE('Total de Pacientes: ' || v_total_pacientes);
END;
/



DECLARE
    v_total_historicos NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Relatório de Histórico de Consultas (RIGHT JOIN):');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');

    FOR rec IN (
        SELECT c.ID_Consulta, c.Data_Consulta, 
               p.Nome AS Paciente, d.Nome AS Dentista,
               h.Motivo_Consulta, h.Observacoes
        FROM Consulta c
        RIGHT JOIN Historico_Consulta h ON c.ID_Consulta = h.ID_Consulta
        LEFT JOIN Paciente p ON c.ID_Paciente = p.ID_Paciente
        LEFT JOIN Dentista d ON c.ID_Dentista = d.ID_Dentista
        ORDER BY c.Data_Consulta DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID Consulta: ' || rec.ID_Consulta);
        DBMS_OUTPUT.PUT_LINE('Data: ' || TO_CHAR(rec.Data_Consulta, 'DD/MM/YYYY HH24:MI'));
        DBMS_OUTPUT.PUT_LINE('Paciente: ' || rec.Paciente);
        DBMS_OUTPUT.PUT_LINE('Dentista: ' || rec.Dentista);
        DBMS_OUTPUT.PUT_LINE('Motivo: ' || rec.Motivo_Consulta);
        DBMS_OUTPUT.PUT_LINE('Observações: ' || rec.Observacoes);
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;

    SELECT COUNT(*) INTO v_total_historicos FROM Historico_Consulta;
    DBMS_OUTPUT.PUT_LINE('Total de Registros Históricos: ' || v_total_historicos);
END;
/


DECLARE
    v_id_paciente NUMBER := 1; 
    v_novo_telefone VARCHAR2(20) := '(11) 99999-8888';
    v_rows_updated NUMBER;
BEGIN
    UPDATE Paciente
    SET Telefone = v_novo_telefone
    WHERE ID_Paciente = v_id_paciente;

    v_rows_updated := SQL%ROWCOUNT;

    IF v_rows_updated > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Telefone atualizado com sucesso para o paciente ID ' || v_id_paciente);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nenhum paciente encontrado com o ID ' || v_id_paciente);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar o telefone: ' || SQLERRM);
        ROLLBACK;
END;
/

DECLARE
    v_id_consulta NUMBER := 1; 
    v_rows_deleted NUMBER;
BEGIN
    DELETE FROM Historico_Consulta
    WHERE ID_Consulta = v_id_consulta;

    v_rows_deleted := SQL%ROWCOUNT;

    IF v_rows_deleted > 0 THEN
        DELETE FROM Consulta
        WHERE ID_Consulta = v_id_consulta;

        DBMS_OUTPUT.PUT_LINE('Consulta e seu histórico deletados com sucesso. ID: ' || v_id_consulta);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nenhuma consulta encontrada com o ID ' || v_id_consulta);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao deletar a consulta: ' || SQLERRM);
        ROLLBACK;
END;
/

