/* Funções de Validação de Entrada de Dados
Desenvolver duas funções para validar a entrada de dados, assegurando que as
informações inseridas estejam em conformidade com as regras de integridade e os
requisitos específicos do projeto.*/

set SERVEROUT on;

-- Validação de Tabelas

-- Funções para Validar Paciente
-- Função para validar todos os dados do paciente durante a inserção
CREATE OR REPLACE FUNCTION Valida_Paciente_Insert(
    p_Nome Paciente.Nome%TYPE,
    p_Data_Nascimento Paciente.Data_Nascimento%TYPE,
    p_CPF Paciente.CPF%TYPE,
    p_Endereco Paciente.Endereco%TYPE,
    p_Telefone Paciente.Telefone%TYPE,
    p_Carteirinha Paciente.Carteirinha%TYPE
) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    -- Validação do Nome
    IF p_Nome IS NULL OR TRIM(p_Nome) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome é obrigatório.');
        RETURN FALSE;
    END IF;

    -- Validação do Endereço
    IF p_Endereco IS NULL OR TRIM(p_Endereco) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Endereço é obrigatório.');
        RETURN FALSE;
    END IF;

    -- Validação do Telefone
    IF p_Telefone IS NULL OR TRIM(p_Telefone) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone é obrigatório.');
        RETURN FALSE;
    ELSIF NOT REGEXP_LIKE(p_Telefone, '^\(\d{2}\)\s\d{4,5}-\d{4}$') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone inválido. Formato esperado: (xx) xxxxx-xxxx.');
        RETURN FALSE;
    END IF;

    -- Validação do CPF
    IF p_CPF IS NULL OR TRIM(p_CPF) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CPF é obrigatório.');
        RETURN FALSE;
    ELSIF NOT REGEXP_LIKE(p_CPF, '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CPF inválido! CPF deve ter 14 caracteres (incluindo pontos e hífen).');
        RETURN FALSE;
    END IF;

    -- Verifica se o CPF já existe na tabela Paciente
    SELECT COUNT(*) INTO v_count
    FROM Paciente
    WHERE CPF = p_CPF;
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CPF já consta na tabela!');
        RETURN FALSE; 
    END IF;

    -- Validação da Data de Nascimento
    IF p_Data_Nascimento IS NULL OR TRIM(p_Data_Nascimento) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Data de nascimento é obrigatória.');
        RETURN FALSE;
    ELSIF p_Data_Nascimento > SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Data de Nascimento não pode ser futura.');
        RETURN FALSE;
    END IF;

    -- Validação da Carteirinha
    IF LENGTH(p_Carteirinha) != 5 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Carteirinha inválida! Deve ter 5 dígitos.');
        RETURN FALSE;
    END IF;

    -- Verifica se a Carteirinha já existe na tabela Paciente
    SELECT COUNT(*) INTO v_count
    FROM Paciente
    WHERE Carteirinha = p_Carteirinha;
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Carteirinha já consta na tabela!');
        RETURN FALSE; 
    END IF;

    DBMS_OUTPUT.PUT_LINE('Paciente válido para inserção.');
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END Valida_Paciente_Insert;
/

-- Função para validar dados do paciente durante a atualização
CREATE OR REPLACE FUNCTION Valida_Paciente_Update(
    p_ID_Paciente Paciente.ID_Paciente%TYPE,
    p_Nome Paciente.Nome%TYPE DEFAULT NULL,
    p_Data_Nascimento Paciente.Data_Nascimento%TYPE DEFAULT NULL,
    p_CPF Paciente.CPF%TYPE DEFAULT NULL,
    p_Endereco Paciente.Endereco%TYPE DEFAULT NULL,
    p_Telefone Paciente.Telefone%TYPE DEFAULT NULL,
    p_Carteirinha Paciente.Carteirinha%TYPE DEFAULT NULL
) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
        FROM Paciente
        WHERE ID_Paciente = p_ID_Paciente;
        IF v_count < 1 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Paciente não consta na tabela!');
            RETURN FALSE; 
        END IF;
        
    -- Validação do Nome (se fornecido)
    IF p_Nome IS NOT NULL AND TRIM(p_Nome) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome não pode ser vazio.');
        RETURN FALSE;
    END IF;

    -- Validação do Endereço (se fornecido)
    IF p_Endereco IS NOT NULL AND TRIM(p_Endereco) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Endereço não pode ser vazio.');
        RETURN FALSE;
    END IF;

    -- Validação do Telefone (se fornecido)
    IF p_Telefone IS NOT NULL AND TRIM(p_Telefone) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone não pode ser vazio.');
        RETURN FALSE;
    ELSIF p_Telefone IS NOT NULL AND NOT REGEXP_LIKE(p_Telefone, '^\(\d{2}\)\s\d{4,5}-\d{4}$') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone inválido. Formato esperado: (xx) xxxxx-xxxx.');
        RETURN FALSE;
    END IF;

    -- Validação do CPF (se fornecido)
    IF p_CPF IS NOT NULL THEN
        IF NOT REGEXP_LIKE(p_CPF, '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})') THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CPF inválido! CPF deve ter 14 caracteres (incluindo pontos e hífen).');
            RETURN FALSE;
        END IF;

        -- Verifica se o CPF já existe na tabela (exceto para o paciente atual)
        SELECT COUNT(*) INTO v_count
        FROM Paciente
        WHERE CPF = p_CPF AND ID_Paciente != p_ID_Paciente;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CPF já consta na tabela!');
            RETURN FALSE; 
        END IF;
    END IF;

    -- Validação da Data de Nascimento (se fornecida)
    IF p_Data_Nascimento IS NOT NULL AND p_Data_Nascimento > SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Data de Nascimento não pode ser futura.');
        RETURN FALSE;
    END IF;

    -- Validação da Carteirinha (se fornecida)
    IF p_Carteirinha IS NOT NULL THEN
        IF LENGTH(p_Carteirinha) != 5 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Carteirinha inválida! Deve ter 5 dígitos.');
            RETURN FALSE;
        END IF;

        -- Verifica se a Carteirinha já existe na tabela (exceto para o paciente atual)
        SELECT COUNT(*) INTO v_count
        FROM Paciente
        WHERE Carteirinha = p_Carteirinha AND ID_Paciente != p_ID_Paciente;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Carteirinha já consta na tabela!');
            RETURN FALSE; 
        END IF;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dados válidos para atualização.');
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END Valida_Paciente_Update;
/

--------------------------------------------------------------------------------

-- Funções para Validar do Dentista 
-- Função para validar todos os dados do dentista durante a inserção
CREATE OR REPLACE FUNCTION Valida_Dentista_Insert(
    p_Nome Dentista.Nome%TYPE,
    p_CRO Dentista.CRO%TYPE,
    p_Especialidade Dentista.Especialidade%TYPE,
    p_Telefone Dentista.Telefone%TYPE
) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    -- Validação do Nome
    IF p_Nome IS NULL OR TRIM(p_Nome) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome é obrigatório.');
        RETURN FALSE;
    END IF;

    -- Validação do CRO
    IF p_CRO IS NULL OR TRIM(p_CRO) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CRO é obrigatório.');
        RETURN FALSE;
    ELSIF NOT REGEXP_LIKE(p_CRO, '^CRO-[0-9]{5}$') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CRO inválido. Formato esperado: CRO-XXXXX.');
        RETURN FALSE;
    END IF;

    -- Verifica se o CRO já existe na tabela Dentista
    SELECT COUNT(*) INTO v_count
    FROM Dentista
    WHERE CRO = p_CRO;
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CRO já consta na tabela!');
        RETURN FALSE; 
    END IF;

    -- Validação da Especialidade
    IF p_Especialidade IS NULL OR TRIM(p_Especialidade) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Especialidade é obrigatória.');
        RETURN FALSE;
    END IF;

    -- Validação do Telefone
    IF p_Telefone IS NULL OR TRIM(p_Telefone) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone é obrigatório.');
        RETURN FALSE;
    ELSIF NOT REGEXP_LIKE(p_Telefone, '^\(\d{2}\)\s\d{4,5}-\d{4}$') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone inválido. Formato esperado: (11) 12345-6789 ou (11) 1234-5678.');
        RETURN FALSE;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dentista válido para inserção.');
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END Valida_Dentista_Insert;
/

-- Função para validar todos os dados do paciente durante a atualização
CREATE OR REPLACE FUNCTION Valida_Dentista_Update(
    p_ID_Dentista Dentista.ID_Dentista%TYPE,
    p_Nome Dentista.Nome%TYPE DEFAULT NULL,
    p_CRO Dentista.CRO%TYPE DEFAULT NULL,
    p_Especialidade Dentista.Especialidade%TYPE DEFAULT NULL,
    p_Telefone Dentista.Telefone%TYPE DEFAULT NULL
) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
        FROM Dentista
        WHERE ID_Dentista = p_ID_Dentista;
        IF v_count < 1 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Dentista não consta na tabela!');
            RETURN FALSE; 
        END IF;

    -- Validação do ID_Dentista
    IF p_ID_Dentista IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ID do dentista é obrigatório para atualização.');
        RETURN FALSE;
    END IF;

    -- Validação do Nome (opcional)
    IF p_Nome IS NOT NULL AND TRIM(p_Nome) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome não pode ser vazio se fornecido.');
        RETURN FALSE;
    END IF;

    -- Validação do CRO (opcional)
    IF p_CRO IS NOT NULL THEN
        IF TRIM(p_CRO) = '' THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CRO não pode ser vazio.');
            RETURN FALSE;
        ELSIF NOT REGEXP_LIKE(p_CRO, '^CRO-[0-9]{5}$') THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CRO deve ter pelo menos 5 caracteres.');
            RETURN FALSE;
        END IF;

        -- Verifica se o CRO já existe na tabela Dentista
        SELECT COUNT(*) INTO v_count
        FROM Dentista
        WHERE CRO = p_CRO AND ID_Dentista != p_ID_Dentista;  -- Verifica se CRO já existe para outro dentista
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CRO já consta na tabela!');
            RETURN FALSE; 
        END IF;
    END IF;

    -- Validação da Especialidade (opcional)
    IF p_Especialidade IS NOT NULL AND TRIM(p_Especialidade) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Especialidade não pode ser vazia se fornecida.');
        RETURN FALSE;
    END IF;

    -- Validação do Telefone (opcional)
    IF p_Telefone IS NOT NULL THEN
        IF TRIM(p_Telefone) = '' THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Telefone não pode ser vazio se fornecido.');
            RETURN FALSE;
        ELSIF NOT REGEXP_LIKE(p_Telefone, '^\(\d{2}\)\s\d{4,5}-\d{4}$') THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Telefone inválido. Formato esperado: (11) 12345-6789 ou (11) 1234-5678.');
            RETURN FALSE;
        END IF;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dentista válido para atualização.');
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END Valida_Dentista_Update;
/

--------------------------------------------------------------------------------

-- Funções para validar Data da Consulta
-- Função para validar dados de inserção na tabela Consulta
CREATE OR REPLACE FUNCTION Valida_Consulta_Insert (
    p_Data_Consulta Consulta.Data_Consulta%TYPE,
    p_ID_Paciente Consulta.ID_Paciente%TYPE,
    p_ID_Dentista Consulta.ID_Dentista%TYPE,
    p_Status Consulta.Status%TYPE
) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    -- Verificar se o Paciente existe
    SELECT COUNT(*) INTO v_count
    FROM Paciente
    WHERE ID_Paciente = p_ID_Paciente;

    IF v_count = 0 OR p_ID_Paciente IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Paciente não encontrado.');
        RETURN FALSE;
    END IF;

    -- Verificar se o Dentista existe
    SELECT COUNT(*) INTO v_count
    FROM Dentista
    WHERE ID_Dentista = p_ID_Dentista;

    IF v_count = 0 OR p_ID_Dentista IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Dentista não encontrado.');
        RETURN FALSE;
    END IF;

    -- Verificar se a Data_Consulta não é nula
    IF p_Data_Consulta IS NULL OR TRIM(p_Data_Consulta) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Data da Consulta não pode ser nula.');
        RETURN FALSE;
    END IF;

    -- Verificar se o Status é válido (valores permitidos: 'AGENDADA', 'CONCLUIDA', 'CANCELADA')
    IF p_Status NOT IN ('AGENDADA', 'CONCLUIDA', 'CANCELADA') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Status inválido. Use: AGENDADA, CONCLUIDA ou CANCELADA.');
        RETURN FALSE;
    END IF;

    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END Valida_Consulta_Insert;
/

-- Função para validar dados de atualização na tabela Consulta
CREATE OR REPLACE FUNCTION Valida_Consulta_Update (
    p_ID_Consulta Consulta.ID_Consulta%TYPE,
    p_Data_Consulta Consulta.Data_Consulta%TYPE DEFAULT NULL,
    p_ID_Paciente Consulta.ID_Paciente%TYPE DEFAULT NULL,
    p_ID_Dentista Consulta.ID_Dentista%TYPE DEFAULT NULL,
    p_Status Consulta.Status%TYPE DEFAULT NULL
) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Consulta
    WHERE ID_Consulta = p_ID_Consulta;
    IF v_count < 1 OR p_ID_Consulta IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Consulta não consta na tabela!');
        RETURN FALSE; 
    END IF;
    
    IF p_ID_Paciente IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Paciente
        WHERE ID_Paciente = p_ID_Paciente;
        
        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Paciente não encontrado.');
            RETURN FALSE;
        END IF;
    END IF;
    
    IF p_ID_Dentista IS NOT NULL THEN
        SELECT COUNT(*) INTO v_count
        FROM Dentista
        WHERE ID_Dentista = p_ID_Dentista;
        
        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Dentista não encontrado.');
            RETURN FALSE;
        END IF;
    END IF;
    
    IF p_Data_Consulta IS NOT NULL AND TRIM(p_Data_Consulta) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Data da Consulta não pode ser vazia se fornecida.');
        RETURN FALSE;
    END IF;
    
    IF p_Status IS NOT NULL AND p_Status NOT IN ('AGENDADA', 'CONCLUIDA', 'CANCELADA') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Status inválido. Use: AGENDADA, CONCLUIDA ou CANCELADA.');
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END Valida_Consulta_Update;
/

--------------------------------------------------------------------------------

-- Função para validar Motivo da consulta e Data de atendimento da consulta
CREATE OR REPLACE FUNCTION Valida_HistoricoConsulta_Insert(
    p_ID_Consulta HistoricoConsulta.ID_Consulta%TYPE,
    p_Data_Atendimento HistoricoConsulta.Data_Atendimento%Type,
    p_Motivo_Consulta HistoricoConsulta.Motivo_Consulta%Type
) RETURN BOOLEAN IS
    v_Count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_Count
    FROM Consulta
    WHERE ID_Consulta = p_ID_Consulta;
    IF v_Count = 0 OR p_ID_Consulta IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Consulta não encontrada.');
        RETURN FALSE;
    END IF;

    IF p_Data_Atendimento IS NULL OR TRIM(p_Data_Atendimento) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Data do Atendimento não pode ser nula.');
        RETURN FALSE;
    END IF;
    
    IF p_Motivo_Consulta IS NULL OR TRIM(p_Motivo_Consulta) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Motivo da consulta não pode ser nula.');
        RETURN FALSE;
    END IF;

    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END Valida_HistoricoConsulta_Insert;
/

CREATE OR REPLACE FUNCTION Valida_HistoricoConsulta_Update(
    p_ID_Historico HistoricoConsulta.ID_Historico%TYPE,
    p_ID_Consulta HistoricoConsulta.ID_Consulta%TYPE DEFAULT NULL,
    p_Data_Atendimento HistoricoConsulta.Data_Atendimento%Type DEFAULT NULL,
    p_Motivo_Consulta HistoricoConsulta.Motivo_Consulta%Type DEFAULT NULL
)RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    -- Verifica se a ID_Historico existe
    SELECT COUNT(*) INTO v_Count
    FROM HistoricoConsulta
    WHERE ID_Historico = p_ID_Historico;

    IF v_Count = 0 OR p_ID_Historico IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Consulta não consta na tabela!');
        RETURN FALSE;
    END IF;

    -- Verifica se a consulta existe na tabela Consulta, se fornecida
    IF p_ID_Consulta IS NOT NULL THEN
        SELECT COUNT(*) INTO v_Count
        FROM Consulta
        WHERE ID_Consulta = p_ID_Consulta;

        IF v_Count = 0 THEN
            RETURN FALSE;
        END IF;
    END IF;
    
    IF p_Data_Atendimento IS NOT NULL AND TRIM(p_Data_Atendimento) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Data do Atendimento não pode ser vazia se fornecida.');
        RETURN FALSE;
    END IF;

    -- Se algum dos campos obrigatórios de atualização estiver preenchido, valida
    IF p_Motivo_Consulta IS NOT NULL AND TRIM(p_Motivo_Consulta) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Motivo da Consulta não pode ser vazia se fornecida.');
        RETURN FALSE;
    END IF;

    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END Valida_HistoricoConsulta_Update;
/