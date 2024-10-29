-- Operações CRUD

set SERVEROUT ON;

-- Paciente
-- Procedure para Inserir Paciente
CREATE OR REPLACE PROCEDURE Insert_Paciente(
    p_Nome Paciente.Nome%TYPE,
    p_Data_Nascimento Paciente.Data_Nascimento%TYPE,
    p_CPF Paciente.CPF%TYPE,
    p_Endereco Paciente.Endereco%TYPE,
    p_Telefone Paciente.Telefone%TYPE,
    p_Carteirinha Paciente.Carteirinha%TYPE
) IS
BEGIN
    -- Validar todos os dados do paciente
    IF Valida_Paciente_Insert(p_Nome, p_Data_Nascimento, p_CPF, p_Endereco, p_Telefone, p_Carteirinha) THEN
        INSERT INTO Paciente (ID_Paciente, Nome, Data_Nascimento, CPF, Endereco, Telefone, Carteirinha)
        VALUES (seq_paciente.NEXTVAL, p_Nome, p_Data_Nascimento, p_CPF, p_Endereco, p_Telefone, p_Carteirinha);
        DBMS_OUTPUT.PUT_LINE('Paciente inserido com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir paciente: ' || SQLERRM);
        ROLLBACK;
END Insert_Paciente;
/

EXECUTE Insert_PACIENTE('João', DATE '2010-12-12', '452.000.444-70', 'Rua Raimundico', '(11) 66121-2322', 76421);

-- Procedure para Atualizar Paciente
CREATE OR REPLACE PROCEDURE Update_Paciente(
    p_ID_Paciente Paciente.ID_Paciente%TYPE,
    p_Nome Paciente.Nome%TYPE DEFAULT NULL,
    p_Data_Nascimento Paciente.Data_Nascimento%TYPE DEFAULT NULL,
    p_CPF Paciente.CPF%TYPE DEFAULT NULL,
    p_Endereco Paciente.Endereco%TYPE DEFAULT NULL,
    p_Telefone Paciente.Telefone%TYPE DEFAULT NULL,
    p_Carteirinha Paciente.Carteirinha%TYPE DEFAULT NULL
) IS
BEGIN
    -- Validar dados do paciente
    IF Valida_Paciente_Update(p_ID_Paciente, p_Nome, p_Data_Nascimento, p_CPF, p_Endereco, p_Telefone, p_Carteirinha) THEN
        UPDATE Paciente
        SET 
            Nome = COALESCE(p_Nome, Nome),
            Data_Nascimento = COALESCE(p_Data_Nascimento, Data_Nascimento),
            CPF = COALESCE(p_CPF, CPF),
            Endereco = COALESCE(p_Endereco, Endereco),
            Telefone = COALESCE(p_Telefone, Telefone),
            Carteirinha = COALESCE(p_Carteirinha, Carteirinha)
        WHERE ID_Paciente = p_ID_Paciente;
        DBMS_OUTPUT.PUT_LINE('Paciente atualizado com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar paciente: ' || SQLERRM);
        ROLLBACK;
END Update_Paciente;
/

EXECUTE Update_Paciente(7, 'Thomas', null, '123.456.789-22', 'Rua Madeiros 143', '(11) 13341-2442');

-- Procedure para Deletar Paciente
CREATE OR REPLACE PROCEDURE Delete_Paciente(
    p_ID_Paciente Paciente.ID_Paciente%TYPE
) IS
BEGIN
    -- Deletar o paciente pelo ID
    DELETE FROM Paciente
    WHERE ID_Paciente = p_ID_Paciente;

    -- Verificar se alguma linha foi deletada
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Paciente deletado com sucesso.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nenhum paciente encontrado com o ID fornecido.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao deletar o paciente: ' || SQLERRM);
        ROLLBACK;
END Delete_Paciente;
/

-- EXECUTE DELETE_PACIENTE(7);

--------------------------------------------------------------------------------

-- Dentista
-- Procedure para Inserir Dentista
CREATE OR REPLACE PROCEDURE Insert_Dentista(
    p_Nome Dentista.Nome%TYPE,
    p_CRO Dentista.CRO%TYPE,
    p_Especialidade Dentista.Especialidade%TYPE,
    p_Telefone Dentista.Telefone%TYPE
) IS
BEGIN
    -- Validação dos dados do Dentista
    IF Valida_Dentista_Insert(p_Nome, p_CRO, p_Especialidade, p_Telefone) THEN
        INSERT INTO Dentista (ID_Dentista, Nome, CRO, Especialidade, Telefone)
        VALUES (seq_dentista.NEXTVAL, p_Nome, p_CRO, p_Especialidade, p_Telefone);
        
        DBMS_OUTPUT.PUT_LINE('Dentista inserido com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para inserção de Dentista.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir dentista: ' || SQLERRM);
        ROLLBACK;
END Insert_Dentista;
/

EXECUTE Insert_Dentista('Dr.Martin', 'CRO-13322', 'RECONSTRUÇÃO', '(11) 1551-1111');

-- Procedure para Atualizar Dentista
CREATE OR REPLACE PROCEDURE Update_Dentista(
    p_ID_Dentista Dentista.ID_Dentista%TYPE,
    p_Nome Dentista.Nome%TYPE DEFAULT NULL,
    p_CRO Dentista.CRO%TYPE DEFAULT NULL,
    p_Especialidade Dentista.Especialidade%TYPE DEFAULT NULL,
    p_Telefone Dentista.Telefone%TYPE DEFAULT NULL
) IS
BEGIN
    -- Validação dos dados do Dentista
    IF Valida_Dentista_Update(p_ID_Dentista, p_Nome, p_CRO, p_Especialidade, p_Telefone) THEN
        UPDATE Dentista
        SET Nome = COALESCE(p_Nome, Nome),
            CRO = COALESCE(p_CRO, CRO),
            Especialidade = COALESCE(p_Especialidade, Especialidade),
            Telefone = COALESCE(p_Telefone, Telefone)
        WHERE ID_Dentista = p_ID_Dentista;
        DBMS_OUTPUT.PUT_LINE('Paciente atualizado com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para atualização de Dentista.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar dentista: ' || SQLERRM);
        ROLLBACK;
END Update_Dentista;
/

EXECUTE Update_Dentista(7, 'Paulin Jr.');

-- Procedure para Deletar Dentista
CREATE OR REPLACE PROCEDURE Delete_Dentista(
    p_ID_Dentista Dentista.ID_Dentista%TYPE
) IS
BEGIN
    DELETE FROM Dentista WHERE ID_Dentista = p_ID_Dentista;

    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Dentista deletado com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nenhum dentista encontrado com o ID fornecido.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao deletar dentista: ' || SQLERRM);
        ROLLBACK;
END Delete_Dentista;
/

EXECUTE Delete_Dentista(7);

--------------------------------------------------------------------------------

-- Consulta
-- Procedure para Inserir Consulta
CREATE OR REPLACE PROCEDURE Insert_Consulta(
    p_Data_Consulta Consulta.Data_Consulta%TYPE,
    p_ID_Paciente Consulta.ID_Paciente%TYPE,
    p_ID_Dentista Consulta.ID_Dentista%TYPE,
    p_Status Consulta.Status%TYPE
) IS
BEGIN
    -- Validar informações da consulta com a função Valida_Consulta_Insert
    IF Valida_Consulta_Insert(p_Data_Consulta, p_ID_Paciente, p_ID_Dentista, UPPER(p_Status)) THEN
        INSERT INTO Consulta (ID_Consulta, Data_Consulta, ID_Paciente, ID_Dentista, Status)
        VALUES (seq_consulta.NEXTVAL, p_Data_Consulta, p_ID_Paciente, p_ID_Dentista, UPPER(p_Status));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Consulta inserida com sucesso.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para a consulta.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir consulta: ' || SQLERRM);
        ROLLBACK;
END Insert_Consulta;
/

EXECUTE INSERT_CONSULTA(TIMESTAMP '2024-10-24 00:00:00', 2, 3, 'cancelada')

-- Função para validar todos os dados da consulta durante a atualização
CREATE OR REPLACE PROCEDURE Update_Consulta(
    p_ID_Consulta Consulta.ID_Consulta%TYPE,
    p_Data_Consulta Consulta.Data_Consulta%TYPE DEFAULT NULL,
    p_ID_Paciente Consulta.ID_Paciente%TYPE DEFAULT NULL,
    p_ID_Dentista Consulta.ID_Dentista%TYPE DEFAULT NULL,
    p_Status Consulta.Status%TYPE DEFAULT NULL
) IS
BEGIN
    -- Validar informações da consulta com a função Valida_Consulta_Update
    IF Valida_Consulta_Update(p_ID_Consulta, p_Data_Consulta, p_ID_Paciente, p_ID_Dentista, UPPER(p_Status)) THEN
        UPDATE Consulta
        SET Data_Consulta = p_Data_Consulta,
            ID_Paciente = p_ID_Paciente,
            ID_Dentista = p_ID_Dentista,
            Status = UPPER(p_Status)
        WHERE ID_Consulta = p_ID_Consulta;

        -- Verificar se alguma linha foi atualizada
        IF SQL%ROWCOUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Consulta atualizada com sucesso.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Nenhuma consulta encontrada com o ID fornecido.');
        END IF;
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para a atualização da consulta.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar consulta: ' || SQLERRM);
        ROLLBACK;
END Update_Consulta;
/
