CREATE OR REPLACE PACKAGE Pkg_Procedures_CRUD_Odontoprev AS

  -- Procedures para Paciente
  PROCEDURE Insert_Paciente(
    p_Nome Paciente.Nome%TYPE,
    p_Data_Nascimento Paciente.Data_Nascimento%TYPE,
    p_CPF Paciente.CPF%TYPE,
    p_Endereco Paciente.Endereco%TYPE,
    p_Telefone Paciente.Telefone%TYPE,
    p_Carteirinha Paciente.Carteirinha%TYPE
  );

  PROCEDURE Update_Paciente(
    p_ID_Paciente Paciente.ID_Paciente%TYPE,
    p_Nome Paciente.Nome%TYPE DEFAULT NULL,
    p_Data_Nascimento Paciente.Data_Nascimento%TYPE DEFAULT NULL,
    p_CPF Paciente.CPF%TYPE DEFAULT NULL,
    p_Endereco Paciente.Endereco%TYPE DEFAULT NULL,
    p_Telefone Paciente.Telefone%TYPE DEFAULT NULL,
    p_Carteirinha Paciente.Carteirinha%TYPE DEFAULT NULL
  );

  PROCEDURE Delete_Paciente(p_ID_Paciente Paciente.ID_Paciente%TYPE);

  -- Procedures para Dentista
  PROCEDURE Insert_Dentista(
    p_Nome Dentista.Nome%TYPE,
    p_CRO Dentista.CRO%TYPE,
    p_Especialidade Dentista.Especialidade%TYPE,
    p_Telefone Dentista.Telefone%TYPE
  );

  PROCEDURE Update_Dentista(
    p_ID_Dentista Dentista.ID_Dentista%TYPE,
    p_Nome Dentista.Nome%TYPE DEFAULT NULL,
    p_CRO Dentista.CRO%TYPE DEFAULT NULL,
    p_Especialidade Dentista.Especialidade%TYPE DEFAULT NULL,
    p_Telefone Dentista.Telefone%TYPE DEFAULT NULL
  );

  PROCEDURE Delete_Dentista(p_ID_Dentista Dentista.ID_Dentista%TYPE);

  -- Procedures para Consulta
  PROCEDURE Insert_Consulta(
    p_Data_Consulta Consulta.Data_Consulta%TYPE,
    p_ID_Paciente Consulta.ID_Paciente%TYPE,
    p_ID_Dentista Consulta.ID_Dentista%TYPE,
    p_Status Consulta.Status%TYPE
  );

  PROCEDURE Update_Consulta(
    p_ID_Consulta Consulta.ID_Consulta%TYPE,
    p_Data_Consulta Consulta.Data_Consulta%TYPE DEFAULT NULL,
    p_ID_Paciente Consulta.ID_Paciente%TYPE DEFAULT NULL,
    p_ID_Dentista Consulta.ID_Dentista%TYPE DEFAULT NULL,
    p_Status Consulta.Status%TYPE DEFAULT NULL
  );

  PROCEDURE Delete_Consulta(p_ID_Consulta Consulta.ID_Consulta%TYPE);

  -- Procedures para Histórico de Consulta
  PROCEDURE Insert_Historico_Consulta(
    p_ID_Consulta Historico_Consulta.ID_Consulta%TYPE,
    p_Data_Atendimento Historico_Consulta.Data_Atendimento%TYPE,
    p_Motivo_Consulta Historico_Consulta.Motivo_Consulta%TYPE,
    p_Observacoes Historico_Consulta.Observacoes%TYPE DEFAULT NULL
  );

  PROCEDURE Update_Historico_Consulta(
    p_ID_Historico Historico_Consulta.ID_Historico%TYPE,
    p_ID_Consulta Historico_Consulta.ID_Consulta%TYPE DEFAULT NULL,
    p_Data_Atendimento Historico_Consulta.Data_Atendimento%TYPE DEFAULT NULL,
    p_Motivo_Consulta Historico_Consulta.Motivo_Consulta%TYPE DEFAULT NULL,
    p_Observacoes Historico_Consulta.Observacoes%TYPE DEFAULT NULL
  );

  PROCEDURE Delete_Historico_Consulta(p_ID_Historico Historico_Consulta.ID_Historico%TYPE);

END Pkg_Procedures_CRUD_Odontoprev;
/

CREATE OR REPLACE PACKAGE BODY Pkg_Procedures_CRUD_Odontoprev AS
    
    -- Paciente
    
    -- Procedure para Inserir Paciente
    PROCEDURE Insert_Paciente(
        p_Nome Paciente.Nome%TYPE,
        p_Data_Nascimento Paciente.Data_Nascimento%TYPE,
        p_CPF Paciente.CPF%TYPE,
        p_Endereco Paciente.Endereco%TYPE,
        p_Telefone Paciente.Telefone%TYPE,
        p_Carteirinha Paciente.Carteirinha%TYPE
    ) IS    
    BEGIN
        -- Validar todos os dados do paciente
        IF Pkg_Fun_Validacao_Odontoprev.Valida_Paciente_Insert(p_Nome, p_Data_Nascimento, p_CPF, p_Endereco, p_Telefone, p_Carteirinha) THEN
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
    
    -- Procedure para Atualizar Paciente
	PROCEDURE Update_Paciente(
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
		IF Pkg_Fun_Validacao_Odontoprev.Valida_Paciente_Update(p_ID_Paciente, p_Nome, p_Data_Nascimento, p_CPF, p_Endereco, p_Telefone, p_Carteirinha) THEN
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
    
    -- Procedure para Deletar Paciente
	PROCEDURE Delete_Paciente(
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
    
    
    -- Dentista
    
    -- Procedure para Inserir Dentista
	PROCEDURE Insert_Dentista(
		p_Nome Dentista.Nome%TYPE,
		p_CRO Dentista.CRO%TYPE,
		p_Especialidade Dentista.Especialidade%TYPE,
		p_Telefone Dentista.Telefone%TYPE
	) IS
	BEGIN
		-- Validação dos dados do Dentista
		IF Pkg_Fun_Validacao_Odontoprev.Valida_Dentista_Insert(p_Nome, p_CRO, UPPER(p_Especialidade), p_Telefone) THEN
			INSERT INTO Dentista (ID_Dentista, Nome, CRO, Especialidade, Telefone)
			VALUES (seq_dentista.NEXTVAL, p_Nome, p_CRO, UPPER(p_Especialidade), p_Telefone);
			
			DBMS_OUTPUT.PUT_LINE('Dentista inserido com sucesso.');
			COMMIT;
		ELSE
			DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para inserção de Dentista.');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao inserir dentista: ' || SQLERRM);
			ROLLBACK;
	END Insert_Dentista;
    
    -- Procedure para Atualizar Dentista
	PROCEDURE Update_Dentista(
		p_ID_Dentista Dentista.ID_Dentista%TYPE,
		p_Nome Dentista.Nome%TYPE DEFAULT NULL,
		p_CRO Dentista.CRO%TYPE DEFAULT NULL,
		p_Especialidade Dentista.Especialidade%TYPE DEFAULT NULL,
		p_Telefone Dentista.Telefone%TYPE DEFAULT NULL
	) IS
	BEGIN
		-- Validação dos dados do Dentista
		IF Pkg_Fun_Validacao_Odontoprev.Valida_Dentista_Update(p_ID_Dentista, p_Nome, p_CRO, UPPER(p_Especialidade), p_Telefone) THEN
			UPDATE Dentista
			SET Nome = COALESCE(p_Nome, Nome),
				CRO = COALESCE(p_CRO, CRO),
				Especialidade = COALESCE(UPPER(p_Especialidade), Especialidade),
				Telefone = COALESCE(p_Telefone, Telefone)
			WHERE ID_Dentista = p_ID_Dentista;
			DBMS_OUTPUT.PUT_LINE('Paciente atualizado com sucesso.');
			COMMIT;
		ELSE
			DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para atualização de Dentista.');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao atualizar dentista: ' || SQLERRM);
			ROLLBACK;
	END Update_Dentista;
    
    -- Procedure para Deletar Dentista
	PROCEDURE Delete_Dentista(
		p_ID_Dentista Dentista.ID_Dentista%TYPE
	) IS
	BEGIN
		DELETE FROM Dentista WHERE ID_Dentista = p_ID_Dentista;

		IF SQL%ROWCOUNT > 0 THEN
			DBMS_OUTPUT.PUT_LINE('Dentista deletado com sucesso.');
			COMMIT;
		ELSE
			DBMS_OUTPUT.PUT_LINE('Nenhum dentista encontrado com o ID fornecido.');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao deletar dentista: ' || SQLERRM);
			ROLLBACK;
	END Delete_Dentista;
    
    
    -- Consulta
    
	-- Procedure para Inserir Consulta
	PROCEDURE Insert_Consulta(
		p_Data_Consulta Consulta.Data_Consulta%TYPE,
		p_ID_Paciente Consulta.ID_Paciente%TYPE,
		p_ID_Dentista Consulta.ID_Dentista%TYPE,
		p_Status Consulta.Status%TYPE
	) IS
	BEGIN
		-- Validar informações da consulta com a função Valida_Consulta_Insert
		IF Pkg_Fun_Validacao_Odontoprev.Valida_Consulta_Insert(p_Data_Consulta, p_ID_Paciente, p_ID_Dentista, UPPER(p_Status)) THEN
			INSERT INTO Consulta (ID_Consulta, Data_Consulta, ID_Paciente, ID_Dentista, Status)
			VALUES (seq_consulta.NEXTVAL, p_Data_Consulta, p_ID_Paciente, p_ID_Dentista, UPPER(p_Status));
			COMMIT;
			DBMS_OUTPUT.PUT_LINE('Consulta inserida com sucesso.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para a consulta.');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao inserir consulta: ' || SQLERRM);
			ROLLBACK;
	END Insert_Consulta;
    
    -- Função para Atualizar Consulta
	PROCEDURE Update_Consulta(
		p_ID_Consulta Consulta.ID_Consulta%TYPE,
		p_Data_Consulta Consulta.Data_Consulta%TYPE DEFAULT NULL,
		p_ID_Paciente Consulta.ID_Paciente%TYPE DEFAULT NULL,
		p_ID_Dentista Consulta.ID_Dentista%TYPE DEFAULT NULL,
		p_Status Consulta.Status%TYPE DEFAULT NULL
	) IS
	BEGIN
		-- Validação dos dados da consulta
		IF Pkg_Fun_Validacao_Odontoprev.Valida_Consulta_Update(p_ID_Consulta, p_Data_Consulta, p_ID_Paciente, p_ID_Dentista, UPPER(p_Status)) THEN
			UPDATE Consulta
			SET Data_Consulta = COALESCE(p_Data_Consulta, Data_Consulta),
				ID_Paciente = COALESCE(p_ID_Paciente, ID_Paciente),
				ID_Dentista = COALESCE(p_ID_Dentista, ID_Dentista),
				Status = COALESCE(UPPER(p_Status), Status)
			WHERE ID_Consulta = p_ID_Consulta;
			DBMS_OUTPUT.PUT_LINE('Consulta atualizada com sucesso.');
			COMMIT;
		ELSE
			DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para atualização de Consulta.');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao atualizar consulta: ' || SQLERRM);
			ROLLBACK;
	END Update_Consulta;
    
    -- Procedure para Deletar Consulta
	PROCEDURE Delete_Consulta(
		p_ID_Consulta Consulta.ID_Consulta%TYPE
	) IS
	BEGIN
		DELETE FROM Consulta WHERE ID_Consulta = p_ID_Consulta;

		IF SQL%ROWCOUNT > 0 THEN
			DBMS_OUTPUT.PUT_LINE('Consulta deletada com sucesso.');
			COMMIT;
		ELSE
			DBMS_OUTPUT.PUT_LINE('Nenhuma consulta encontrada com o ID fornecido.');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao deletar consulta: ' || SQLERRM);
			ROLLBACK;
	END Delete_Consulta;
    
    
    -- Historico de Consulta
    
    -- Procedure para Inserir Histórico de Consulta
    PROCEDURE Insert_Historico_Consulta(
		p_ID_Consulta Historico_Consulta.ID_Consulta%TYPE,
		p_Data_Atendimento Historico_Consulta.Data_Atendimento%TYPE,
		p_Motivo_Consulta Historico_Consulta.Motivo_Consulta%TYPE,
		p_Observacoes Historico_Consulta.Observacoes%TYPE DEFAULT NULL
	) IS
	BEGIN
		-- Validar dados da inserção
		IF Pkg_Fun_Validacao_Odontoprev.Valida_Historico_Consulta_Insert(p_ID_Consulta, p_Data_Atendimento, p_Motivo_Consulta) THEN
			INSERT INTO Historico_Consulta (ID_Historico, ID_Consulta, Data_Atendimento, Motivo_Consulta, Observacoes)
			VALUES (seq_historico.NEXTVAL, p_ID_Consulta, p_Data_Atendimento, p_Motivo_Consulta, p_Observacoes);
			
			DBMS_OUTPUT.PUT_LINE('Histórico de consulta inserido com sucesso.');
			COMMIT;
		ELSE
			DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para inserção de histórico de consulta.');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao inserir histórico de consulta: ' || SQLERRM);
			ROLLBACK;
	END Insert_Historico_Consulta;
    
    -- Procedure para Atualizar Histórico de Consulta
    PROCEDURE Update_Historico_Consulta(
		p_ID_Historico Historico_Consulta.ID_Historico%TYPE,
		p_ID_Consulta Historico_Consulta.ID_Consulta%TYPE DEFAULT NULL,
		p_Data_Atendimento Historico_Consulta.Data_Atendimento%TYPE DEFAULT NULL,
		p_Motivo_Consulta Historico_Consulta.Motivo_Consulta%TYPE DEFAULT NULL,
		p_Observacoes Historico_Consulta.Observacoes%TYPE DEFAULT NULL
	) IS
	BEGIN
		-- Validar dados da atualização
		IF Pkg_Fun_Validacao_Odontoprev.Valida_Historico_Consulta_Update(p_ID_Historico, p_ID_Consulta, p_Data_Atendimento, p_Motivo_Consulta) THEN
			UPDATE Historico_Consulta
			SET 
				ID_Consulta = COALESCE(p_ID_Consulta, ID_Consulta),
				Data_Atendimento = COALESCE(p_Data_Atendimento, Data_Atendimento),
				Motivo_Consulta = COALESCE(p_Motivo_Consulta, Motivo_Consulta),
				Observacoes = COALESCE(p_Observacoes, Observacoes)
			WHERE ID_Historico = p_ID_Historico;

			DBMS_OUTPUT.PUT_LINE('Histórico de consulta atualizado com sucesso.');
			COMMIT;
		ELSE
			DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para atualização de histórico de consulta.');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao atualizar histórico de consulta: ' || SQLERRM);
			ROLLBACK;
	END Update_Historico_Consulta;
    
    -- Procedure para Deletar Histórico de Consulta
    PROCEDURE Delete_Historico_Consulta(
		p_ID_Historico Historico_Consulta.ID_Historico%TYPE
	) IS
	BEGIN
		DELETE FROM Historico_Consulta WHERE ID_Historico = p_ID_Historico;

		IF SQL%ROWCOUNT > 0 THEN
			DBMS_OUTPUT.PUT_LINE('Historico de consulta deletada com sucesso.');
			COMMIT;
		ELSE
			DBMS_OUTPUT.PUT_LINE('Nenhum historico de consulta encontrada com o ID fornecido.');
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Erro ao deletar historico de consulta: ' || SQLERRM);
			ROLLBACK;
	END Delete_Historico_Consulta;
    
END Pkg_Procedures_CRUD_Odontoprev;
/