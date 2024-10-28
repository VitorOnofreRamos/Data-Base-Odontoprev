/* Fun��es de Valida��o de Entrada de Dados
Desenvolver duas fun��es para validar a entrada de dados, assegurando que as
informa��es inseridas estejam em conformidade com as regras de integridade e os
requisitos espec�ficos do projeto.*/

set SERVEROUT on;

-- Valida��o de Tabelas

-- Fun��es para Validar Paciente
-- Fun��o para validar todos os dados do paciente durante a inser��o
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
    -- Valida��o do Nome
    IF p_Nome IS NULL OR TRIM(p_Nome) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome � obrigat�rio.');
        RETURN FALSE;
    END IF;

    -- Valida��o do Endere�o
    IF p_Endereco IS NULL OR TRIM(p_Endereco) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Endere�o � obrigat�rio.');
        RETURN FALSE;
    END IF;

    -- Valida��o do Telefone
    IF p_Telefone IS NULL OR TRIM(p_Telefone) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone � obrigat�rio.');
        RETURN FALSE;
    ELSIF NOT REGEXP_LIKE(p_Telefone, '^\(\d{2}\)\s\d{4,5}-\d{4}$') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone inv�lido. Formato esperado: (xx) xxxxx-xxxx.');
        RETURN FALSE;
    END IF;

    -- Valida��o do CPF
    IF p_CPF IS NULL OR TRIM(p_CPF) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CPF � obrigat�rio.');
        RETURN FALSE;
    ELSIF NOT REGEXP_LIKE(p_CPF, '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CPF inv�lido! CPF deve ter 14 caracteres (incluindo pontos e h�fen).');
        RETURN FALSE;
    END IF;

    -- Verifica se o CPF j� existe na tabela Paciente
    SELECT COUNT(*) INTO v_count
    FROM Paciente
    WHERE CPF = p_CPF;
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CPF j� consta na tabela!');
        RETURN FALSE; 
    END IF;

    -- Valida��o da Data de Nascimento
    IF p_Data_Nascimento > SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Data de Nascimento n�o pode ser futura.');
        RETURN FALSE;
    END IF;

    -- Valida��o da Carteirinha
    IF LENGTH(p_Carteirinha) != 5 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Carteirinha inv�lida! Deve ter 5 d�gitos.');
        RETURN FALSE;
    END IF;

    -- Verifica se a Carteirinha j� existe na tabela Paciente
    SELECT COUNT(*) INTO v_count
    FROM Paciente
    WHERE Carteirinha = p_Carteirinha;
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Carteirinha j� consta na tabela!');
        RETURN FALSE; 
    END IF;

    DBMS_OUTPUT.PUT_LINE('Paciente v�lido para inser��o.');
    RETURN TRUE;
END Valida_Paciente_Insert;
/

-- Fun��o para validar dados do paciente durante a atualiza��o
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
    -- Valida��o do Nome (se fornecido)
    IF p_Nome IS NOT NULL AND TRIM(p_Nome) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome n�o pode ser vazio.');
        RETURN FALSE;
    END IF;

    -- Valida��o do Endere�o (se fornecido)
    IF p_Endereco IS NOT NULL AND TRIM(p_Endereco) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Endere�o n�o pode ser vazio.');
        RETURN FALSE;
    END IF;

    -- Valida��o do Telefone (se fornecido)
    IF p_Telefone IS NOT NULL AND TRIM(p_Telefone) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone n�o pode ser vazio.');
        RETURN FALSE;
    ELSIF p_Telefone IS NOT NULL AND NOT REGEXP_LIKE(p_Telefone, '^\(\d{2}\)\s\d{4,5}-\d{4}$') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone inv�lido. Formato esperado: (xx) xxxxx-xxxx.');
        RETURN FALSE;
    END IF;

    -- Valida��o do CPF (se fornecido)
    IF p_CPF IS NOT NULL THEN
        IF NOT REGEXP_LIKE(p_CPF, '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})') THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CPF inv�lido! CPF deve ter 14 caracteres (incluindo pontos e h�fen).');
            RETURN FALSE;
        END IF;

        -- Verifica se o CPF j� existe na tabela (exceto para o paciente atual)
        SELECT COUNT(*) INTO v_count
        FROM Paciente
        WHERE CPF = p_CPF AND ID_Paciente != p_ID_Paciente;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CPF j� consta na tabela!');
            RETURN FALSE; 
        END IF;
    END IF;

    -- Valida��o da Data de Nascimento (se fornecida)
    IF p_Data_Nascimento IS NOT NULL AND p_Data_Nascimento > SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Data de Nascimento n�o pode ser futura.');
        RETURN FALSE;
    END IF;

    -- Valida��o da Carteirinha (se fornecida)
    IF p_Carteirinha IS NOT NULL THEN
        IF LENGTH(p_Carteirinha) != 5 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Carteirinha inv�lida! Deve ter 5 d�gitos.');
            RETURN FALSE;
        END IF;

        -- Verifica se a Carteirinha j� existe na tabela (exceto para o paciente atual)
        SELECT COUNT(*) INTO v_count
        FROM Paciente
        WHERE Carteirinha = p_Carteirinha AND ID_Paciente != p_ID_Paciente;
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Carteirinha j� consta na tabela!');
            RETURN FALSE; 
        END IF;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dados v�lidos para atualiza��o.');
    RETURN TRUE;
END Valida_Paciente_Update;
/

--------------------------------------------------------------------------------

-- Fun��o para Validar do Dentista 
-- Fun��o para validar todos os dados do paciente durante a inser��o
CREATE OR REPLACE FUNCTION Valida_Dentista_Insert(
    p_Nome Dentista.Nome%TYPE,
    p_CRO Dentista.CRO%TYPE,
    p_Especialidade Dentista.Especialidade%TYPE,
    p_Telefone Dentista.Telefone%TYPE
) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    -- Valida��o do Nome
    IF p_Nome IS NULL OR TRIM(p_Nome) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome � obrigat�rio.');
        RETURN FALSE;
    END IF;

    -- Valida��o do CRO
    IF p_CRO IS NULL OR TRIM(p_CRO) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CRO � obrigat�rio.');
        RETURN FALSE;
    ELSIF NOT REGEXP_LIKE(p_CRO, '^CRO-[0-9]{5}$') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CRO inv�lido. Formato esperado: CRO-XXXXX.');
        RETURN FALSE;
    END IF;

    -- Verifica se o CRO j� existe na tabela Dentista
    SELECT COUNT(*) INTO v_count
    FROM Dentista
    WHERE CRO = p_CRO;
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: CRO j� consta na tabela!');
        RETURN FALSE; 
    END IF;

    -- Valida��o da Especialidade
    IF p_Especialidade IS NULL OR TRIM(p_Especialidade) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Especialidade � obrigat�ria.');
        RETURN FALSE;
    END IF;

    -- Valida��o do Telefone
    IF p_Telefone IS NULL OR TRIM(p_Telefone) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone � obrigat�rio.');
        RETURN FALSE;
    ELSIF NOT REGEXP_LIKE(p_Telefone, '^\(\d{2}\)\s\d{4,5}-\d{4}$') THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Telefone inv�lido. Formato esperado: (11) 12345-6789 ou (11) 1234-5678.');
        RETURN FALSE;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dentista v�lido para inser��o.');
    RETURN TRUE;
END Valida_Dentista_Insert;
/

-- Fun��o para validar todos os dados do paciente durante a atualiza��o
CREATE OR REPLACE FUNCTION Valida_Dados_Dentista_Update(
    p_ID_Dentista Dentista.ID_Dentista%TYPE,
    p_Nome Dentista.Nome%TYPE,
    p_CRO Dentista.CRO%TYPE,
    p_Especialidade Dentista.Especialidade%TYPE,
    p_Telefone Dentista.Telefone%TYPE
) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    -- Valida��o do ID_Dentista
    IF p_ID_Dentista IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ID do dentista � obrigat�rio para atualiza��o.');
        RETURN FALSE;
    END IF;

    -- Valida��o do Nome (opcional)
    IF p_Nome IS NOT NULL AND TRIM(p_Nome) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome n�o pode ser vazio se fornecido.');
        RETURN FALSE;
    END IF;

    -- Valida��o do CRO (opcional)
    IF p_CRO IS NOT NULL THEN
        IF TRIM(p_CRO) = '' THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CRO n�o pode ser vazio.');
            RETURN FALSE;
        ELSIF LENGTH(p_CRO) < 5 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CRO deve ter pelo menos 5 caracteres.');
            RETURN FALSE;
        END IF;

        -- Verifica se o CRO j� existe na tabela Dentista
        SELECT COUNT(*) INTO v_count
        FROM Dentista
        WHERE CRO = p_CRO AND ID_Dentista != p_ID_Dentista;  -- Verifica se CRO j� existe para outro dentista
        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CRO j� consta na tabela!');
            RETURN FALSE; 
        END IF;
    END IF;

    -- Valida��o da Especialidade (opcional)
    IF p_Especialidade IS NOT NULL AND TRIM(p_Especialidade) = '' THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Especialidade n�o pode ser vazia se fornecida.');
        RETURN FALSE;
    END IF;

    -- Valida��o do Telefone (opcional)
    IF p_Telefone IS NOT NULL THEN
        IF TRIM(p_Telefone) = '' THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Telefone n�o pode ser vazio se fornecido.');
            RETURN FALSE;
        ELSIF NOT REGEXP_LIKE(p_Telefone, '^\(\d{2}\)\s\d{4,5}-\d{4}$') THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Telefone inv�lido. Formato esperado: (11) 12345-6789 ou (11) 1234-5678.');
            RETURN FALSE;
        END IF;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dentista v�lido para atualiza��o.');
    RETURN TRUE;
END Valida_Dados_Dentista_Update;
/

--------------------------------------------------------------------------------
-- Fun��o p�ra validar Data da Consulta e Status da Consulta
CREATE OR REPLACE FUNCTION Valida_Consulta(
    p_Data_Consulta Consulta.DATA_CONSULTA%Type,
    p_Status Consulta.Status%Type
) RETURN BOOLEAN IS
BEGIN
    -- Verificar se a data da consulta � v�lida (pode ser presente ou futura)
    IF p_Data_Consulta < (SYSDATE - INTERVAL '1' DAY) THEN
        RETURN FALSE;
    END IF;

    -- Verificar se o status � v�lido (deve ser 'Agendada', 'Conclu�da' ou 'Cancelada')
    IF NOT (p_Status IN ('AGENDADA', 'CONCLU�DA', 'CANCELADA')) THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END Valida_Consulta;
/


-- Fun��o para validar Motivo da consulta e Data de atendimento da consulta
CREATE OR REPLACE FUNCTION Valida_HistoricoConsulta(
    p_Motivo_Consulta HistoricoConsulta.MOTIVO_CONSULTA%Type,
    p_Data_Atendimento HistoricoConsulta.Data_Atendimento%Type
) RETURN BOOLEAN IS
BEGIN
    -- Verificar se o motivo da consulta n�o � nulo ou vazio
    IF p_Motivo_Consulta IS NULL OR p_Motivo_Consulta = '' THEN
        RETURN FALSE;
    END IF;

    -- Verificar se a data de atendimento n�o � futura
    IF p_Data_Atendimento > SYSDATE THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END Valida_HistoricoConsulta;
/
