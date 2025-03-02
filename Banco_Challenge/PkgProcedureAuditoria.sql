set SERVEROUTPUT on;

CREATE OR REPLACE PACKAGE pkg_auditoria AS
    PROCEDURE registrar_auditoria(
        p_nome_tabela    VARCHAR2,
        p_id_registro    NUMBER,
        p_tipo_operacao  VARCHAR2,
        p_dados_antigos  VARCHAR2,
        p_dados_novos    VARCHAR2
    );
END pkg_auditoria;
/

CREATE OR REPLACE PACKAGE BODY pkg_auditoria AS
    PROCEDURE registrar_auditoria(
        p_nome_tabela    VARCHAR2,
        p_id_registro    NUMBER,
        p_tipo_operacao  VARCHAR2,
        p_dados_antigos  VARCHAR2,
        p_dados_novos    VARCHAR2
    ) IS
    BEGIN
        INSERT INTO Auditoria_Odontoprev (
            ID_AUDITORIA, NOME_TABELA, ID_REGISTRO, 
            TIPO_OPERACAO, DATA_HORA, USUARIO, 
            DADOS_ANTIGOS, DADOS_NOVOS
        )
        VALUES (
            SEQ_AUDITORIA.NEXTVAL,
            p_nome_tabela,
            p_id_registro,
            p_tipo_operacao,
            SYSTIMESTAMP,
            USER,
            p_dados_antigos,
            p_dados_novos
        );
    END registrar_auditoria;
END pkg_auditoria;
/