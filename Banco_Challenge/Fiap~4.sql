-- Operações CRUD

-- Paciente
set SERVEROUT ON;

CREATE OR REPLACE PROCEDURE Insert_Paciente(
    p_Nome Paciente.Nome%TYPE,
    p_Data_Nascimento Paciente.Data_Nascimento%TYPE,
    p_CPF Paciente.CPF%TYPE,
    p_Endereco Paciente.Endereco%TYPE,
    p_Telefone Paciente.Telefone%TYPE,
    p_Carteirinha Paciente.Carteirinha%TYPE
) IS
BEGIN
    -- Validar CPF e Data de Nascimento
    IF Valida_Paciente(NULL, p_CPF, p_Data_Nascimento, p_Carteirinha) THEN
        INSERT INTO Paciente (ID_Paciente, Nome, Data_Nascimento, CPF, Endereco, Telefone, Carteirinha)
        VALUES (seq_paciente.NEXTVAL, p_Nome, p_Data_Nascimento, p_CPF, p_Endereco, p_Telefone, p_Carteirinha);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Paciente inserido com sucesso.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir paciente: ' || SQLERRM);
        ROLLBACK;
END Insert_Paciente;
/

-- EXECUTE Insert_PACIENTE('Paulin Bacana', DATE '2000-05-20', '198.999.779-01', 'Rua A, 123', '(11) 98888-7777', 55855);

--

CREATE OR REPLACE PROCEDURE Select_Paciente(
    p_ID_Paciente Paciente.ID_Paciente%Type
) IS
    v_Nome Paciente.Nome%TYPE;
    v_Data_Nascimento Paciente.Data_Nascimento%TYPE;
    v_CPF Paciente.CPF%TYPE;
    v_Endereco Paciente.Endereco%TYPE;
    v_Telefone Paciente.Telefone%TYPE;
    v_Carteirinha Paciente.Carteirinha%TYPE;
BEGIN
    -- Selecionar o paciente pelo ID
    SELECT Nome, Data_Nascimento, CPF, Endereco, Telefone, Carteirinha
    INTO v_Nome, v_Data_Nascimento, v_CPF, v_Endereco, v_Telefone, v_Carteirinha
    FROM Paciente
    WHERE ID_Paciente = p_ID_Paciente;

    -- Exibir os dados do paciente
    DBMS_OUTPUT.PUT_LINE('Nome: ' || v_Nome);
    DBMS_OUTPUT.PUT_LINE('Data de Nascimento: ' || TO_CHAR(v_Data_Nascimento, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('CPF: ' || v_CPF);
    DBMS_OUTPUT.PUT_LINE('Endereço: ' || v_Endereco);
    DBMS_OUTPUT.PUT_LINE('Telefone: ' || v_Telefone);
    DBMS_OUTPUT.PUT_LINE('Carteirinha: ' || v_Carteirinha);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Paciente não encontrado com o ID fornecido.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao selecionar o paciente: ' || SQLERRM);
END Select_Paciente;
/

-- EXECUTE SELECT_PACIENTE(6);

--

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

-- EXECUTE DELETE_PACIENTE(6);

--

CREATE OR REPLACE PROCEDURE Update_Paciente(
    p_ID_Paciente IN Paciente.ID_Paciente%TYPE,
    p_Nome IN Paciente.Nome%TYPE DEFAULT NULL,
    p_Data_Nascimento IN Paciente.Data_Nascimento%TYPE DEFAULT NULL,
    p_CPF IN Paciente.CPF%TYPE DEFAULT NULL,
    p_Endereco IN Paciente.Endereco%TYPE DEFAULT NULL,
    p_Telefone IN Paciente.Telefone%TYPE DEFAULT NULL,
    p_Carteirinha IN Paciente.Carteirinha%TYPE DEFAULT NULL
) IS
BEGIN
    -- Validar CPF, Data de Nascimento e Carteirinha
    IF Valida_Paciente(p_ID_Paciente, p_CPF, p_Data_Nascimento, p_Carteirinha) THEN
        -- Dados válidos, executar o UPDATE
        UPDATE Paciente
        SET Nome = COALESCE(p_Nome, Nome),
            Data_Nascimento = COALESCE(p_Data_Nascimento, Data_Nascimento),
            CPF = COALESCE(p_CPF, CPF),
            Endereco = COALESCE(p_Endereco, Endereco),
            Telefone = COALESCE(p_Telefone, Telefone),
            Carteirinha = COALESCE(p_Carteirinha, Carteirinha)
        WHERE ID_Paciente = p_ID_Paciente;

        -- Verificar se alguma linha foi atualizada
        IF SQL%ROWCOUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Paciente atualizado com sucesso.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Nenhum paciente encontrado com o ID fornecido.');
        END IF;
    ELSE
        -- Dados inválidos, mostrar mensagem de erro
        DBMS_OUTPUT.PUT_LINE('Erro: Dados do paciente inválidos. Verifique as regras de integridade.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar o paciente: ' || SQLERRM);
        ROLLBACK;
END Update_Paciente;
/

-- EXECUTE Update_Paciente(6, NULL, DATE '1999-05-20');