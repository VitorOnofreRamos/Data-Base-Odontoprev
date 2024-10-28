-- Operações CRUD
set SERVEROUT ON;

-- Paciente

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

EXECUTE Insert_PACIENTE('Eduardo', DATE '2020-05-20', '122.000.444-76', 'Rua do Junin', '(11) 11121-2222', 78557);

--

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

-- EXECUTE Update_Paciente(7, 'Paulin Bacana', null, '123.456.789-22', 'DOUGLAS', '(11) 15521-2222');

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

-- EXECUTE DELETE_PACIENTE(7);

------------------------------------------------------------------------------------

-- Dentista

