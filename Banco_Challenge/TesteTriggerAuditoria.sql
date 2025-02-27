set SERVEROUTPUT on;

CREATE OR REPLACE TRIGGER TR_AUDITORIA_ODONTOPREV
    AFTER INSERT OR UPDATE OR DELETE
    ON Paciente
    FOR EACH ROW
DECLARE
    v_dados_antigos VARCHAR2(4000);
    v_dados_novos VARCHAR2(4000);
    v_operacao VARCHAR2(10);
    v_id_registro NUMBER;
BEGIN
    -- Determina o tipo de operação realizada (INSERT, UPDATE ou DELETE)
    IF INSERTING THEN
        v_id_registro := :NEW.ID_Paciente;
        v_operacao := 'INSERT';
        v_dados_novos := 'ID_Paciente: ' || :NEW.ID_Paciente || 
                         ', Nome: ' || :NEW.Nome ||
                         ', Data_Nascimento: ' || TO_CHAR(:NEW.Data_Nascimento, 'YYYY-MM-DD') ||
                         ', CPF: ' || :NEW.CPF ||
                         ', Endereco: ' || :NEW.Endereco ||
                         ', Telefone: ' || :NEW.Telefone ||
                         ', Carteirinha: ' || :NEW.Carteirinha;
    ELSIF UPDATING THEN
        v_id_registro := :OLD.ID_Paciente;
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID_Paciente: ' || :OLD.ID_Paciente || 
                           ', Nome: ' || :OLD.Nome ||
                           ', Data_Nascimento: ' || TO_CHAR(:OLD.Data_Nascimento, 'YYYY-MM-DD') ||
                           ', CPF: ' || :OLD.CPF ||
                           ', Endereco: ' || :OLD.Endereco ||
                           ', Telefone: ' || :OLD.Telefone ||
                           ', Carteirinha: ' || :OLD.Carteirinha;
        
        v_id_registro := :NEW.ID_Paciente;                           
        v_dados_novos := 'ID_Paciente: ' || :NEW.ID_Paciente || 
                         ', Nome: ' || :NEW.Nome ||
                         ', Data_Nascimento: ' || TO_CHAR(:NEW.Data_Nascimento, 'YYYY-MM-DD') ||
                         ', CPF: ' || :NEW.CPF ||
                         ', Endereco: ' || :NEW.Endereco ||
                         ', Telefone: ' || :NEW.Telefone ||
                         ', Carteirinha: ' || :NEW.Carteirinha;
    ELSIF DELETING THEN
        v_id_registro := :OLD.ID_Paciente;
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID_Paciente: ' || :OLD.ID_Paciente || 
                           ', Nome: ' || :OLD.Nome ||
                           ', Data_Nascimento: ' || TO_CHAR(:OLD.Data_Nascimento, 'YYYY-MM-DD') ||
                           ', CPF: ' || :OLD.CPF ||
                           ', Endereco: ' || :OLD.Endereco ||
                           ', Telefone: ' || :OLD.Telefone ||
                           ', Carteirinha: ' || :OLD.Carteirinha;
        v_dados_novos := 'Registro Removido';
    END IF;

    -- Insere o registro na tabela de auditoria
    INSERT INTO Auditoria_Odontoprev (ID_AUDITORIA, NOME_TABELA, ID_REGISTRO, TIPO_OPERACAO, DATA_HORA, USUARIO, DADOS_ANTIGOS, DADOS_NOVOS)
    VALUES (SEQ_AUDITORIA.NEXTVAL, 'Paciente', v_id_registro, v_operacao, SYSTIMESTAMP, USER, v_dados_antigos, v_dados_novos);

END;
/

EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('Pablo Oliveira', DATE '2004-08-06', '122.233.553-44', 'Rua das Noruga, 728', '(21) 99843-5432', 72231);
EXECUTE pkg_procedures_crud_odontoprev.Update_PACIENTE(6, 'Pablo Oliveira Jr', DATE '2004-08-06', '122.233.553-44', 'Rua das Noruga, 728', '(21) 99843-5432', 72231);
EXECUTE pkg_procedures_crud_odontoprev.Delete_PACIENTE(6);