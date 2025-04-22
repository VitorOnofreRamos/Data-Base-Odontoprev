CREATE OR REPLACE PACKAGE Pkg_Fun_Validacao_Odontoprev AS

    -- Valida��o de Tabelas
    FUNCTION Valida_Paciente_Insert(
        p_Nome Paciente.Nome%TYPE,
        p_Data_Nascimento Paciente.Data_Nascimento%TYPE,
        p_CPF Paciente.CPF%TYPE,
        p_CEP Paciente.CEP%TYPE,
        p_Endereco Paciente.Endereco%TYPE,
        p_Telefone Paciente.Telefone%TYPE,
        p_Carteirinha Paciente.Carteirinha%TYPE
    ) RETURN BOOLEAN;
    
    FUNCTION Valida_Paciente_Update(
        p_ID_Paciente Paciente.ID_Paciente%TYPE,
        p_Nome Paciente.Nome%TYPE DEFAULT NULL,
        p_Data_Nascimento Paciente.Data_Nascimento%TYPE DEFAULT NULL,
        p_CPF Paciente.CPF%TYPE DEFAULT NULL,
        p_CEP Paciente.CEP%TYPE DEFAULT NULL,
        p_Endereco Paciente.Endereco%TYPE DEFAULT NULL,
        p_Telefone Paciente.Telefone%TYPE DEFAULT NULL,
        p_Carteirinha Paciente.Carteirinha%TYPE DEFAULT NULL
    ) RETURN BOOLEAN;
    
    FUNCTION Valida_Dentista_Insert(
        p_Nome Dentista.Nome%TYPE,
        p_CRO Dentista.CRO%TYPE,
        p_Especialidade Dentista.Especialidade%TYPE,
        p_Telefone Dentista.Telefone%TYPE
    ) RETURN BOOLEAN;
    
    FUNCTION Valida_Dentista_Update(
        p_ID_Dentista Dentista.ID_Dentista%TYPE,
        p_Nome Dentista.Nome%TYPE DEFAULT NULL,
        p_CRO Dentista.CRO%TYPE DEFAULT NULL,
        p_Especialidade Dentista.Especialidade%TYPE DEFAULT NULL,
        p_Telefone Dentista.Telefone%TYPE DEFAULT NULL
    ) RETURN BOOLEAN;
    
    FUNCTION Valida_Consulta_Insert (
        p_Data_Consulta Consulta.Data_Consulta%TYPE,
        p_ID_Paciente Consulta.ID_Paciente%TYPE,
        p_ID_Dentista Consulta.ID_Dentista%TYPE,
        p_Status Consulta.Status%TYPE
    ) RETURN BOOLEAN;
    
    FUNCTION Valida_Consulta_Update (
        p_ID_Consulta Consulta.ID_Consulta%TYPE,
        p_Data_Consulta Consulta.Data_Consulta%TYPE DEFAULT NULL,
        p_ID_Paciente Consulta.ID_Paciente%TYPE DEFAULT NULL,
        p_ID_Dentista Consulta.ID_Dentista%TYPE DEFAULT NULL,
        p_Status Consulta.Status%TYPE DEFAULT NULL
    ) RETURN BOOLEAN;
    
    FUNCTION Valida_Historico_Consulta_Insert(
        p_ID_Consulta Historico_Consulta.ID_Consulta%TYPE,
        p_Data_Atendimento Historico_Consulta.Data_Atendimento%Type,
        p_Motivo_Consulta Historico_Consulta.Motivo_Consulta%Type
    ) RETURN BOOLEAN;
    
    FUNCTION Valida_Historico_Consulta_Update(
        p_ID_Historico Historico_Consulta.ID_Historico%TYPE,
        p_ID_Consulta Historico_Consulta.ID_Consulta%TYPE DEFAULT NULL,
        p_Data_Atendimento Historico_Consulta.Data_Atendimento%Type DEFAULT NULL,
        p_Motivo_Consulta Historico_Consulta.Motivo_Consulta%Type DEFAULT NULL
    )RETURN BOOLEAN;
END Pkg_Fun_Validacao_Odontoprev;
/

CREATE OR REPLACE PACKAGE BODY Pkg_Fun_Validacao_Odontoprev AS

    -- Fun��es para validar Paciente:
    
    -- Fun��o para validar todos os dados do paciente durante a inser��o
    FUNCTION Valida_Paciente_Insert(
        p_Nome Paciente.Nome%TYPE,
        p_Data_Nascimento Paciente.Data_Nascimento%TYPE,
        p_CPF Paciente.CPF%TYPE,
        p_CEP Paciente.CEP%TYPE,
        p_Endereco Paciente.Endereco%TYPE,
        p_Telefone Paciente.Telefone%TYPE,
        p_Carteirinha Paciente.Carteirinha%TYPE
    ) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        -- Valida��o do Nome
        IF Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Nome) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Nome � obrigat�rio.');
            RETURN FALSE;
        END IF;
    
    	-- Validacao de CEP
        IF NOT Pkg_Fun_Auxiliares.Valida_CEP(p_CEP) THEN
        	DBMS_OUTPUT.PUT_LINE('Erro: CEP inv�lido! CEP deve ter 9 caracteres (incluindo h�fen).');
            RETURN FALSE;
        END IF;

        -- Valida��o do Endere�o
        IF Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Endereco) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Endere�o � obrigat�rio.');
            RETURN FALSE;
        END IF;

        -- Valida��o do Telefone
        IF NOT Pkg_Fun_Auxiliares.Valida_Telefone(p_Telefone) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Telefone inv�lido. Formato esperado: (xx) xxxxx-xxxx.');
            RETURN FALSE;
        END IF;

        -- Valida��o do CPF
        IF NOT Pkg_Fun_Auxiliares.Valida_CPF(p_CPF) THEN
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
        IF NOT Pkg_Fun_Auxiliares.Valida_Data_Nascimento(p_Data_Nascimento) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Data de Nascimento n�o pode ser futura.');
            RETURN FALSE;
        END IF;

        -- Valida��o da Carteirinha
        IF NOT Pkg_Fun_Auxiliares.Valida_Carteirinha(p_Carteirinha) THEN
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
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
            RETURN FALSE;
    END Valida_Paciente_Insert;
    
    -- Fun��o para validar dados do paciente durante a atualiza��o
    FUNCTION Valida_Paciente_Update(
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
            DBMS_OUTPUT.PUT_LINE('Erro: Paciente n�o consta na tabela!');
            RETURN FALSE; 
        END IF;
        
        -- Valida��o do ID_Paciente
        IF p_ID_Paciente IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ID do paciente � obrigat�rio para atualiza��o.');
            RETURN FALSE;
        END IF;
        
        -- Valida��o do Nome (se fornecido)
        IF p_Nome IS NOT NULL AND Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Nome) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Nome n�o pode ser vazio.');
            RETURN FALSE;
        END IF;
        
        -- Validacao de CEP
        IF NOT Pkg_Fun_Auxiliares.Valida_CEP(p_CEP) THEN
        	DBMS_OUTPUT.PUT_LINE('Erro: CEP inv�lido! CEP deve ter 9 caracteres (incluindo h�fen).');
            RETURN FALSE;
        END IF;

        -- Valida��o do Endere�o (se fornecido)
        IF p_Endereco IS NOT NULL AND Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Endereco) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Endere�o n�o pode ser vazio.');
            RETURN FALSE;
        END IF;

        -- Valida��o do Telefone (se fornecido)
        IF p_Telefone IS NOT NULL AND NOT Pkg_Fun_Auxiliares.Valida_Telefone(p_Telefone) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Telefone inv�lido. Formato esperado: (xx) xxxxx-xxxx.');
            RETURN FALSE;
        END IF;

        -- Valida��o do CPF (se fornecido)
        IF p_CPF IS NOT NULL AND NOT Pkg_Fun_Auxiliares.Valida_CPF(p_CPF) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: CPF inv�lido! CPF deve ter 14 caracteres (incluindo pontos e h�fen).');
            RETURN FALSE;
        END IF;

        -- Verifica se o CPF j� existe na tabela (exceto para o paciente atual)
        IF p_CPF IS NOT NULL THEN
            SELECT COUNT(*) INTO v_count
            FROM Paciente
            WHERE CPF = p_CPF AND ID_Paciente != p_ID_Paciente;
            IF v_count > 0 THEN
                DBMS_OUTPUT.PUT_LINE('Erro: CPF j� consta na tabela!');
                RETURN FALSE; 
            END IF;
        END IF;

        -- Valida��o da Data de Nascimento (se fornecida)
        IF p_Data_Nascimento IS NOT NULL AND NOT Pkg_Fun_Auxiliares.Valida_Data_Nascimento(p_Data_Nascimento) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Data de Nascimento n�o pode ser futura.');
            RETURN FALSE;
        END IF;

        -- Valida��o da Carteirinha (se fornecida)
            IF p_Carteirinha IS NOT NULL AND NOT Pkg_Fun_Auxiliares.Valida_Carteirinha(p_Carteirinha) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Carteirinha inv�lida! Deve ter 5 d�gitos.');
            RETURN FALSE;
        END IF;
    
        -- Verifica se a Carterinha j� existe na tabela (exceto para o paciente atual)
        IF p_Carteirinha IS NOT NULL THEN
            SELECT COUNT(*) INTO v_count
            FROM Paciente
            WHERE Carteirinha = p_Carteirinha AND ID_Paciente != p_ID_Paciente;
            IF v_count > 0 THEN
                DBMS_OUTPUT.PUT_LINE('Erro: Carterinha j� consta na tabela!');
                RETURN FALSE;
            END IF;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Dados v�lidos para atualiza��o.');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
            RETURN FALSE;
    END Valida_Paciente_Update;
    
    
    -- Fun��es para validar Dentista :
    
    -- Fun��o para validar todos os dados do dentista durante a inser��o
    FUNCTION Valida_Dentista_Insert(
        p_Nome Dentista.Nome%TYPE,
        p_CRO Dentista.CRO%TYPE,
        p_Especialidade Dentista.Especialidade%TYPE,
        p_Telefone Dentista.Telefone%TYPE
    ) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        -- Valida��o do Nome
        IF Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Nome) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Nome � obrigat�rio.');
            RETURN FALSE;
        END IF;

        -- Valida��o do CRO
        IF NOT Pkg_Fun_Auxiliares.Valida_CRO(p_CRO) THEN
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
        IF Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Especialidade) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Especialidade � obrigat�ria.');
            RETURN FALSE;
        END IF;

        -- Valida��o do Telefone
        IF NOT Pkg_Fun_Auxiliares.Valida_Telefone(p_Telefone) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Telefone inv�lido. Formato esperado: (11) 12345-6789 ou (11) 1234-5678.');
            RETURN FALSE;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Dentista v�lido para inser��o.');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
            RETURN FALSE;
    END Valida_Dentista_Insert;

    -- Fun��o para validar todos os dados do paciente durante a atualiza��o
    FUNCTION Valida_Dentista_Update(
        p_ID_Dentista Dentista.ID_Dentista%TYPE,
        p_Nome Dentista.Nome%TYPE DEFAULT NULL,
        p_CRO Dentista.CRO%TYPE DEFAULT NULL,
        p_Especialidade Dentista.Especialidade%TYPE DEFAULT NULL,
        p_Telefone Dentista.Telefone%TYPE DEFAULT NULL
    ) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        -- Verifica se o dentista existe
        SELECT COUNT(*) INTO v_count
        FROM Dentista
        WHERE ID_Dentista = p_ID_Dentista;
        IF v_count < 1 THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Dentista n�o consta na tabela!');
            RETURN FALSE; 
        END IF;

        -- Valida��o do ID_Dentista
        IF p_ID_Dentista IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Erro: ID do dentista � obrigat�rio para atualiza��o.');
            RETURN FALSE;
        END IF;

        -- Valida��o do Nome (opcional)
        IF p_Nome IS NOT NULL AND Pkg_Fun_Auxiliares.Is_Null_OR_Empty(p_Nome) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Nome n�o pode ser vazio se fornecido.');
            RETURN FALSE;
        END IF;

        -- Valida��o do CRO (opcional)
        IF p_CRO IS NOT NULL THEN
            IF NOT Pkg_Fun_Auxiliares.Valida_CRO(p_CRO) THEN
                DBMS_OUTPUT.PUT_LINE('Erro: CRO inv�lido. Formato esperado: CRO-XXXXX');
                RETURN FALSE;
            END IF;

            -- Verifica se o CRO j� existe na tabela Dentista
            SELECT COUNT(*) INTO v_count
            FROM Dentista
            WHERE CRO = p_CRO AND ID_Dentista != p_ID_Dentista; 
            IF v_count > 0 THEN
                DBMS_OUTPUT.PUT_LINE('Erro: CRO j� consta na tabela!');
                RETURN FALSE; 
            END IF;
        END IF;

        -- Valida��o da Especialidade (opcional)
        IF p_Especialidade IS NOT NULL AND Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Especialidade) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Especialidade n�o pode ser vazia se fornecida.');
            RETURN FALSE;
        END IF;

        -- Valida��o do Telefone (opcional)
        IF p_Telefone IS NOT NULL THEN
            IF NOT Pkg_Fun_Auxiliares.Valida_Telefone(p_Telefone) THEN
                DBMS_OUTPUT.PUT_LINE('Erro: Telefone inv�lido. Formato esperado: (11) 12345-6789 ou (11) 1234-5678.');
                RETURN FALSE;
            END IF;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Dentista v�lido para atualiza��o.');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
            RETURN FALSE;
    END Valida_Dentista_Update;
    
    
    -- Fun��es para validar Consulta
    
    -- Fun��o para validar dados de inser��o na tabela Consulta
    FUNCTION Valida_Consulta_Insert (
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
            DBMS_OUTPUT.PUT_LINE('Erro: Paciente n�o encontrado.');
            RETURN FALSE;
        END IF;

        -- Verificar se o Dentista existe
        SELECT COUNT(*) INTO v_count
        FROM Dentista
        WHERE ID_Dentista = p_ID_Dentista;
        IF v_count = 0 OR p_ID_Dentista IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Dentista n�o encontrado.');
            RETURN FALSE;
        END IF;

        -- Verificar se a Data_Consulta n�o � nula
        IF Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Data_Consulta) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Data da Consulta n�o pode ser nula.');
            RETURN FALSE;
        END IF;

        -- Verificar se o Status � v�lido (valores permitidos: 'AGENDADA', 'CONCLUIDA', 'CANCELADA')
        IF NOT Pkg_Fun_Auxiliares.Valida_Status_Consulta(p_Status) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Status inv�lido. Use: AGENDADA, CONCLUIDA ou CANCELADA.');
            RETURN FALSE;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Consulta v�lida para inser��o.');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
            RETURN FALSE;
    END Valida_Consulta_Insert;

    -- Fun��o para validar dados de atualiza��o na tabela Consulta
    FUNCTION Valida_Consulta_Update (
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
        IF v_count < 0 OR p_ID_Consulta IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Consulta n�o consta na tabela!');
            RETURN FALSE; 
        END IF;
    
        IF p_ID_Paciente IS NOT NULL THEN
            SELECT COUNT(*) INTO v_count
            FROM Paciente
            WHERE ID_Paciente = p_ID_Paciente;
            IF v_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Erro: Paciente n�o encontrado.');
                RETURN FALSE;
            END IF;
        END IF;
    
        IF p_ID_Dentista IS NOT NULL THEN
            SELECT COUNT(*) INTO v_count
            FROM Dentista
            WHERE ID_Dentista = p_ID_Dentista;
            IF v_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Erro: Dentista n�o encontrado.');
                RETURN FALSE;
            END IF;
        END IF;
    
        IF p_Data_Consulta IS NOT NULL AND Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Data_Consulta) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Data da Consulta n�o pode ser vazia se fornecida.');
            RETURN FALSE;
        END IF;
    
        IF p_Status IS NOT NULL AND NOT Pkg_Fun_Auxiliares.Valida_Status_Consulta(p_Status) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Status inv�lido. Use: AGENDADA, CONCLUIDA ou CANCELADA.');
            RETURN FALSE;
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('Consulta v�lida para atualiza��o.');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
            RETURN FALSE;
    END Valida_Consulta_Update;
    
    
    -- Fun��es para validar Hist�rico de Consulta (motivo da consulta e data de atendimento da consulta)

    -- Fun��o para validar dados de inser��o da tabela Historico_Consulta
    FUNCTION Valida_Historico_Consulta_Insert(
        p_ID_Consulta Historico_Consulta.ID_Consulta%TYPE,
        p_Data_Atendimento Historico_Consulta.Data_Atendimento%Type,
        p_Motivo_Consulta Historico_Consulta.Motivo_Consulta%Type
    ) RETURN BOOLEAN IS
        v_Count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_Count
        FROM Consulta
        WHERE ID_Consulta = p_ID_Consulta;
        IF v_Count = 0 OR p_ID_Consulta IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Consulta n�o encontrada.');
            RETURN FALSE;
        END IF;

        IF Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Data_Atendimento) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Data do Atendimento n�o pode ser nula.');
            RETURN FALSE;
        END IF;
    
        IF Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Motivo_Consulta) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Motivo da consulta n�o pode ser nula.');
            RETURN FALSE;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Hist�rico de consulta v�lido para inser��o.');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
            RETURN FALSE;
    END Valida_Historico_Consulta_Insert;

    -- Fun��o para validar dados de atualiza��o na tabela Historico_Consulta
    FUNCTION Valida_Historico_Consulta_Update(
        p_ID_Historico Historico_Consulta.ID_Historico%TYPE,
        p_ID_Consulta Historico_Consulta.ID_Consulta%TYPE DEFAULT NULL,
        p_Data_Atendimento Historico_Consulta.Data_Atendimento%Type DEFAULT NULL,
        p_Motivo_Consulta Historico_Consulta.Motivo_Consulta%Type DEFAULT NULL
    )RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        -- Verifica se a ID_Historico existe
        SELECT COUNT(*) INTO v_Count
        FROM Historico_Consulta
        WHERE ID_Historico = p_ID_Historico;
    
        IF v_Count = 0 OR p_ID_Historico IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Historico n�o consta na tabela!');
            RETURN FALSE;
        END IF;

        -- Verifica se a consulta existe na tabela Consulta, se fornecida
        IF p_ID_Consulta IS NOT NULL THEN
            SELECT COUNT(*) INTO v_Count
            FROM Consulta
            WHERE ID_Consulta = p_ID_Consulta;

            IF v_Count = 0 THEN
                RETURN FALSE;
                DBMS_OUTPUT.PUT_LINE('Erro: Consulta n�o consta na tabela!');
            END IF;
        END IF;
    
        IF p_Data_Atendimento IS NOT NULL AND Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Data_Atendimento) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Data do Atendimento n�o pode ser vazia se fornecida.');
            RETURN FALSE;
        END IF;

        -- Se algum dos campos obrigat�rios de atualiza��o estiver preenchido, valida
        IF p_Motivo_Consulta IS NOT NULL AND Pkg_Fun_Auxiliares.Is_Null_Or_Empty(p_Motivo_Consulta) THEN
            DBMS_OUTPUT.PUT_LINE('Erro: Motivo da Consulta n�o pode ser vazia se fornecida.');
            RETURN FALSE;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Hist�rico de consulta v�lido para atualiza��o');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
            RETURN FALSE;
    END Valida_Historico_Consulta_Update;
        
END Pkg_Fun_Validacao_Odontoprev;
/