-- Operações CRUD

-- Paciente
set SERVEROUT ON;

CREATE OR REPLACE PROCEDURE CREATE_Paciente(
    p_Nome Paciente.Nome%TYPE,
    p_Data_Nascimento Paciente.Data_Nascimento%TYPE,
    p_CPF Paciente.CPF%TYPE,
    p_Endereco Paciente.Endereco%TYPE,
    p_Telefone Paciente.Telefone%TYPE,
    p_Carteirinha Paciente.Carteirinha%TYPE
) IS
BEGIN
    -- Validar CPF e Data de Nascimento
    IF Valida_Paciente(p_CPF, p_Data_Nascimento, p_Carteirinha) THEN
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
END CREATE_Paciente;
/

EXECUTE CREATE_PACIENTE('Paulin Bacana', DATE '1990-05-20', '198.999.999-01', 'Rua A, 123', '(11) 98888-7777', 55555);


CREATE OR REPLACE PROCEDURE Update_Paciente(
    p_ID_Paciente Paciente ,
    p_Nome Paciente.Nome%TYPE,
    p_Data_Nascimento Paciente.Data_Nascimento%TYPE,
    p_CPF Paciente.CPF%TYPE,
    p_Endereco Paciente.Endereco%TYPE,
    p_Telefone Paciente.Telefone%TYPE,
    p_Carteirinha Paciente.Carteirinha%TYPE
) IS
BEGIN
    -- Verificar a validade dos dados usando a função de validação
    IF Valida_Paciente(p_Nome, p_Data_Nascimento, p_CPF, p_Endereco, p_Telefone, p_Carteirinha) THEN
        -- Dados válidos, executar o UPDATE
        UPDATE Paciente
        SET Nome = p_Nome,
            Data_Nascimento = p_Data_Nascimento,
            CPF = p_CPF,
            Endereco = p_Endereco,
            Telefone = p_Telefone,
            Carteirinha = p_Carteirinha
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