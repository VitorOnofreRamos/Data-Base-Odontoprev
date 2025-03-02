-- Trigger auditoria paciente
CREATE OR REPLACE TRIGGER trg_auditoria_paciente
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
    END IF;

    -- Insere o registro na tabela de auditoria
    INSERT INTO Auditoria_Odontoprev (ID_AUDITORIA, NOME_TABELA, ID_REGISTRO, TIPO_OPERACAO, DATA_HORA, USUARIO, DADOS_ANTIGOS, DADOS_NOVOS)
    VALUES (SEQ_AUDITORIA.NEXTVAL, 'Paciente', v_id_registro, v_operacao, SYSTIMESTAMP, USER, v_dados_antigos, v_dados_novos);
END;
/

-- Trigger auditoria dentista
CREATE OR REPLACE TRIGGER trg_auditoria_dentista
    AFTER INSERT OR UPDATE OR DELETE
    ON Dentista
    FOR EACH ROW
DECLARE
    v_dados_antigos VARCHAR2(4000);
    v_dados_novos VARCHAR2(4000);
    v_operacao VARCHAR2(10);
    v_id_registro NUMBER;
BEGIN
    -- Determina o tipo de operação realizada (INSERT, UPDATE ou DELETE)
    IF INSERTING THEN
        v_id_registro := :NEW.ID_Dentista;
        v_operacao := 'INSERT';
        v_dados_novos := 'ID_Dentista: ' || :NEW.ID_Dentista || 
                         ', Nome: ' || :NEW.Nome ||
                         ', CRO: ' || :NEW.CRO ||
                         ', Especialidade: ' || :NEW.Especialidade ||
                         ', Telefone: ' || :NEW.Telefone;
        ELSIF UPDATING THEN
        v_id_registro := :OLD.ID_Dentista;
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID_Dentista: ' || :OLD.ID_Dentista || 
                         ', Nome: ' || :OLD.Nome ||
                         ', CRO: ' || :OLD.CRO ||
                         ', Especialidade: ' || :OLD.Especialidade ||
                         ', Telefone: ' || :OLD.Telefone;
        
        v_id_registro := :NEW.ID_Dentista;                           
        v_dados_novos := 'ID_Dentista: ' || :NEW.ID_Dentista || 
                         ', Nome: ' || :NEW.Nome ||
                         ', CRO: ' || :NEW.CRO ||
                         ', Especialidade: ' || :NEW.Especialidade ||
                         ', Telefone: ' || :NEW.Telefone;
    ELSIF DELETING THEN
        v_id_registro := :OLD.ID_Dentista;
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID_Dentista: ' || :OLD.ID_Dentista || 
                         ', Nome: ' || :OLD.Nome ||
                         ', CRO: ' || :OLD.CRO ||
                         ', Especialidade: ' || :OLD.Especialidade ||
                         ', Telefone: ' || :OLD.Telefone;
    END IF;
    
    -- Insere o registro na tabela de auditoria
    INSERT INTO Auditoria_Odontoprev (ID_AUDITORIA, NOME_TABELA, ID_REGISTRO, TIPO_OPERACAO, DATA_HORA, USUARIO, DADOS_ANTIGOS, DADOS_NOVOS)
    VALUES (SEQ_AUDITORIA.NEXTVAL, 'Dentista', v_id_registro, v_operacao, SYSTIMESTAMP, USER, v_dados_antigos, v_dados_novos);
END;
/

-- Trigger auditoria Consulta
CREATE OR REPLACE TRIGGER trg_auditoria_consulta
    AFTER INSERT OR UPDATE OR DELETE
    ON Consulta
    FOR EACH ROW
DECLARE
    v_dados_antigos VARCHAR2(4000);
    v_dados_novos VARCHAR2(4000);
    v_operacao VARCHAR2(10);
    v_id_registro NUMBER;
BEGIN
    -- Determina o tipo de operação realizada (INSERT, UPDATE ou DELETE)
    IF INSERTING THEN
        v_id_registro := :NEW.ID_Consulta;
        v_operacao := 'INSERT';
        v_dados_novos := 'ID_Consulta: ' || :NEW.ID_Consulta || 
                         ', Data_Consulta: ' || TO_CHAR(:NEW.Data_Consulta, 'YYYY-MM-DD HH:MI:SS') ||
                         ', ID_Paciente: ' || :NEW.ID_Paciente ||
                         ', ID_Dentista: ' || :NEW.ID_Dentista ||
                         ', Status: ' || :NEW.Status;
    ELSIF UPDATING THEN
        v_id_registro := :OLD.ID_Consulta;
        v_operacao := 'INSERT';
        v_dados_antigos := 'ID_Consulta: ' || :OLD.ID_Consulta || 
                         ', Data_Consulta: ' || TO_CHAR(:OLD.Data_Consulta, 'YYYY-MM-DD HH:MI:SS') ||
                         ', ID_Paciente: ' || :OLD.ID_Paciente ||
                         ', ID_Dentista: ' || :OLD.ID_Dentista ||
                         ', Status: ' || :OLD.Status;
        
        v_id_registro := :NEW.ID_Consulta;                           
        v_dados_novos := 'ID_Consulta: ' || :NEW.ID_Consulta || 
                         ', Data_Consulta: ' || TO_CHAR(:NEW.Data_Consulta, 'YYYY-MM-DD HH:MI:SS') ||
                         ', ID_Paciente: ' || :NEW.ID_Paciente ||
                         ', ID_Dentista: ' || :NEW.ID_Dentista ||
                         ', Status: ' || :NEW.Status;
    ELSIF DELETING THEN
        v_id_registro := :OLD.ID_Consulta;
        v_operacao := 'INSERT';
        v_dados_antigos := 'ID_Consulta: ' || :OLD.ID_Consulta || 
                         ', Data_Consulta: ' || TO_CHAR(:OLD.Data_Consulta, 'YYYY-MM-DD HH:MI:SS') ||
                         ', ID_Paciente: ' || :OLD.ID_Paciente ||
                         ', ID_Dentista: ' || :OLD.ID_Dentista ||
                         ', Status: ' || :OLD.Status;
    END IF;

    -- Insere o registro na tabela de auditoria
    INSERT INTO Auditoria_Odontoprev (ID_AUDITORIA, NOME_TABELA, ID_REGISTRO, TIPO_OPERACAO, DATA_HORA, USUARIO, DADOS_ANTIGOS, DADOS_NOVOS)
    VALUES (SEQ_AUDITORIA.NEXTVAL, 'Consulta', v_id_registro, v_operacao, SYSTIMESTAMP, USER, v_dados_antigos, v_dados_novos);
END;
/

-- Trigger auditoria Histórico Consulta
CREATE OR REPLACE TRIGGER trg_auditoria_historico
    AFTER INSERT OR UPDATE OR DELETE
    ON Historico_Consulta
    FOR EACH ROW
DECLARE
    v_dados_antigos VARCHAR2(4000);
    v_dados_novos VARCHAR2(4000);
    v_operacao VARCHAR2(10);
    v_id_registro NUMBER;
BEGIN
    -- Determina o tipo de operação realizada (INSERT, UPDATE ou DELETE)
    IF INSERTING THEN
        v_id_registro := :NEW.ID_Historico;
        v_operacao := 'INSERT';
        v_dados_novos := 'ID_Historico: ' || :NEW.ID_Historico ||
                         ', ID_Consulta: ' || :NEW.ID_Consulta || 
                         ', Data_Atendimento: ' || TO_CHAR(:NEW.Data_Atendimento, 'YYYY-MM-DD HH:MI:SS') ||
                         ', Motivo_Consulta: ' || :NEW.Motivo_Consulta ||
                         ', Observacoes: ' || :NEW.Observacoes;
    ELSIF UPDATING THEN
        v_id_registro := :OLD.ID_Historico;
        v_operacao := 'INSERT';
        v_dados_antigos := 'ID_Historico: ' || :OLD.ID_Historico ||
                         ', ID_Consulta: ' || :OLD.ID_Consulta || 
                         ', Data_Atendimento: ' || TO_CHAR(:OLD.Data_Atendimento, 'YYYY-MM-DD HH:MI:SS') ||
                         ', Motivo_Consulta: ' || :OLD.Motivo_Consulta ||
                         ', Observacoes: ' || :OLD.Observacoes;
        
        v_id_registro := :NEW.ID_Historico;                           
        v_dados_novos := 'ID_Historico: ' || :NEW.ID_Historico ||
                         ', ID_Consulta: ' || :NEW.ID_Consulta || 
                         ', Data_Atendimento: ' || TO_CHAR(:NEW.Data_Atendimento, 'YYYY-MM-DD HH:MI:SS') ||
                         ', Motivo_Consulta: ' || :NEW.Motivo_Consulta ||
                         ', Observacoes: ' || :NEW.Observacoes;
    ELSIF DELETING THEN
        v_id_registro := :OLD.ID_Historico;
        v_operacao := 'INSERT';
        v_dados_antigos := 'ID_Historico: ' || :OLD.ID_Historico ||
                         ', ID_Consulta: ' || :OLD.ID_Consulta || 
                         ', Data_Atendimento: ' || TO_CHAR(:OLD.Data_Atendimento, 'YYYY-MM-DD HH:MI:SS') ||
                         ', Motivo_Consulta: ' || :OLD.Motivo_Consulta ||
                         ', Observacoes: ' || :OLD.Observacoes;
    END IF;

    -- Insere o registro na tabela de auditoria
    INSERT INTO Auditoria_Odontoprev (ID_AUDITORIA, NOME_TABELA, ID_REGISTRO, TIPO_OPERACAO, DATA_HORA, USUARIO, DADOS_ANTIGOS, DADOS_NOVOS)
    VALUES (SEQ_AUDITORIA.NEXTVAL, 'Historico_Consulta', v_id_registro, v_operacao, SYSTIMESTAMP, USER, v_dados_antigos, v_dados_novos);
END;
/