CREATE OR REPLACE PACKAGE Pkg_Fun_Auxiliares AS

    -- Funções Auxiliares de Validação
    FUNCTION Is_Null_Or_Empty(value IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION Valida_CPF(cpf IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION Valida_Telefone(telefone IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION Valida_Carteirinha(carteirinha IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION Valida_Data_Nascimento(data_nascimento IN DATE) RETURN BOOLEAN;
    FUNCTION Valida_CRO(cro IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION Valida_Status_Consulta(status IN VARCHAR2) RETURN BOOLEAN;

END Pkg_Fun_Auxiliares;
/

CREATE OR REPLACE PACKAGE BODY Pkg_Fun_Auxiliares AS

    -- Função para verificar se um campo é nulo ou vazio
    FUNCTION Is_Null_Or_Empty(value IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN (value IS NULL OR TRIM(value) = '');
    END Is_Null_Or_Empty;
    
    -- Função para validar CPF
    FUNCTION Valida_CPF(cpf IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN REGEXP_LIKE(cpf, '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})');
    END Valida_CPF;
    
    -- Função para validar Telefone
    FUNCTION Valida_Telefone(telefone IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN REGEXP_LIKE(telefone, '^\(\d{2}\)\s\d{4,5}-\d{4}$');
    END Valida_Telefone;
    
    -- Função para validar Carteirinha
    FUNCTION Valida_Carteirinha(carteirinha IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN LENGTH(carteirinha) = 5;
    END Valida_Carteirinha;

    -- Função para validar Data de Nascimento
    FUNCTION Valida_Data_Nascimento(data_nascimento IN DATE) RETURN BOOLEAN IS
    BEGIN
        RETURN (data_nascimento < SYSDATE);
    END Valida_Data_Nascimento;
    
    -- Função para validar CRO
    FUNCTION Valida_CRO(cro IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN REGEXP_LIKE(cro, '^CRO-[0-9]{5}$');
    END Valida_CRO;
    
    -- Função para validar Status da Consulta
    FUNCTION Valida_Status_Consulta(status IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN status IN ('AGENDADA', 'CONCLUIDA', 'CANCELADA');
    END Valida_Status_Consulta;

END Pkg_Fun_Auxiliares;
/