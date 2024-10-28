/* Fun��es de Valida��o de Entrada de Dados
Desenvolver duas fun��es para validar a entrada de dados, assegurando que as
informa��es inseridas estejam em conformidade com as regras de integridade e os
requisitos espec�ficos do projeto.

Fun��es criadas

1. Validar CPF
2. Validar Data Nascimento
*/

set SERVEROUT on;

/*
CREATE OR REPLACE FUNCTION validar_CPF(p_CPF IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
    IF LENGTH(p_CPF) <> 14 OR REGEXP_LIKE(p_CPF, '[^0-9.-]') THEN
        DBMS_OUTPUT.PUT_LINE('CPF inv�lido! CPF deve ter 14 caracteres (incluindo pontos e h�fen).');
        RETURN FALSE;
    END IF;
    
    -- Verifica se o CPF j� existe na tabela Paciente
    FOR rec IN (SELECT 1 FROM Paciente WHERE CPF = p_CPF) LOOP
        DBMS_OUTPUT.PUT_LINE('CPF consta na tabela!');
        RETURN FALSE;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('CPF v�lido.');
    RETURN TRUE;
END validar_CPF;
/

--

CREATE OR REPLACE FUNCTION validar_DataNascimento(p_Data IN DATE) RETURN BOOLEAN IS
BEGIN
    IF p_Data > SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('A Data de Nascimento inv�lida! A Data de Nascimento n�o pode estar no futuro.');
        RETURN FALSE;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('A Data de Nascimento v�lida');
    RETURN TRUE;
END validar_DataNascimento;
/
*/

-- Valida��o de Tabelas

-- Fun��o para Validar CPF e Data de Nascimento do Paciente
CREATE OR REPLACE FUNCTION Valida_Paciente(
    p_CPF Paciente.CPF%Type,
    p_Data_Nascimento Paciente.Data_Nascimento%Type,
    p_Carteirinha Paciente.Carteirinha%Type
) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    -- Valida��o do CPF (simplificada)
    IF LENGTH(p_CPF) != 14 OR REGEXP_LIKE(p_CPF, '[^0-9.-]') THEN
        DBMS_OUTPUT.PUT_LINE('CPF inv�lido! CPF deve ter 14 caracteres (incluindo pontos e h�fen).');
        RETURN FALSE;
    END IF;
    
    -- Verifica se o CPF j� existe na tabela Paciente
    /*FOR rec IN (SELECT 1 FROM Paciente WHERE CPF = p_CPF) LOOP
        DBMS_OUTPUT.PUT_LINE('CPF j� consta na tabela!');
        RETURN FALSE;
    END LOOP;*/
    
    SELECT COUNT(*) INTO v_count
    FROM Paciente
    WHERE CPF = p_CPF;
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('CPF j� consta na tabela!');
        RETURN FALSE; 
    END IF;

    -- Verificar se a data de nascimento n�o � futura
    IF p_Data_Nascimento > SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('A Data de Nascimento inv�lida! A Data de Nascimento n�o pode estar no futuro.');
        RETURN FALSE;
    END IF;
    
    IF LENGTH(p_Carteirinha) != 5 THEN
        DBMS_OUTPUT.PUT_LINE('Carterinha inv�lida! Carterinha deve ser uma sequ�ncia de 5 n�meros.');
        RETURN FALSE;
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM Paciente
    WHERE Carteirinha = p_Carteirinha;
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Carterinha j� consta na tabela!');
        RETURN FALSE; 
    END IF;

    DBMS_OUTPUT.PUT_LINE('Paciente V�lido.');
    RETURN TRUE;
END Valida_Paciente;
/

-- Fun��o para Validar CRO e Especialidade do Dentista 
CREATE OR REPLACE FUNCTION Valida_Dentista(
    p_CRO Dentista.CRO%Type,
    p_Especialidade Dentista.Especialidade%Type
) RETURN BOOLEAN IS
BEGIN
    -- Valida��o do CRO (deve seguir o formato padr�o CRO-XXXXX)
    IF NOT REGEXP_LIKE(p_CRO, '^CRO-[0-9]{5}$') THEN
        RETURN FALSE;
    END IF;

    -- Verificar se a especialidade n�o � nula ou vazia
    IF p_Especialidade IS NULL OR p_Especialidade = '' THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END Valida_Dentista;
/

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
    IF NOT (p_Status IN ('Agendada', 'Conclu�da', 'Cancelada')) THEN
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
