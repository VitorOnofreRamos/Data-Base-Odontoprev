-- Inserção de dados teste
set SERVEROUTPUT on;

-- Inserir 5 registros na tabela Paciente
INSERT INTO Paciente (ID_Paciente, Nome, Data_Nascimento, CPF, Endereco, Telefone, Carteirinha)
VALUES (seq_paciente.NEXTVAL, 'João da Silva', DATE '1990-05-20', '123.456.789-01', 'Rua A, 123', '(11) 98888-7777', 10001);

INSERT INTO Paciente (ID_Paciente, Nome, Data_Nascimento, CPF, Endereco, Telefone, Carteirinha)
VALUES (seq_paciente.NEXTVAL, 'Maria Oliveira', DATE '1985-10-15', '234.567.890-12', 'Rua B, 456', '(11) 97777-6666', 10002);

INSERT INTO Paciente (ID_Paciente, Nome, Data_Nascimento, CPF, Endereco, Telefone, Carteirinha)
VALUES (seq_paciente.NEXTVAL, 'Carlos Souza', DATE '1992-03-10', '345.678.901-23', 'Rua C, 789', '(11) 96666-5555', 10003);

INSERT INTO Paciente (ID_Paciente, Nome, Data_Nascimento, CPF, Endereco, Telefone, Carteirinha)
VALUES (seq_paciente.NEXTVAL, 'Ana Ferreira', DATE '1978-07-22', '456.789.012-34', 'Rua D, 101', '(11) 95555-4444', 10004);

INSERT INTO Paciente (ID_Paciente, Nome, Data_Nascimento, CPF, Endereco, Telefone, Carteirinha)
VALUES (seq_paciente.NEXTVAL, 'Pedro Martins', DATE '2000-01-05', '567.890.123-45', 'Rua E, 202', '(11) 94444-3333', 10005);

-- Inserir 5 registros na tabela Dentista
INSERT INTO Dentista (ID_Dentista, Nome, CRO, Especialidade, Telefone)
VALUES (seq_dentista.NEXTVAL, 'Dr. Eduardo Lima', 'CRO-12345', 'Ortodontia', '(11) 91234-5678');

INSERT INTO Dentista (ID_Dentista, Nome, CRO, Especialidade, Telefone)
VALUES (seq_dentista.NEXTVAL, 'Dra. Juliana Souza', 'CRO-23456', 'Endodontia', '(11) 92345-6789');

INSERT INTO Dentista (ID_Dentista, Nome, CRO, Especialidade, Telefone)
VALUES (seq_dentista.NEXTVAL, 'Dr. Marcos Santos', 'CRO-34567', 'Cirurgia', '(11) 93456-7890');

INSERT INTO Dentista (ID_Dentista, Nome, CRO, Especialidade, Telefone)
VALUES (seq_dentista.NEXTVAL, 'Dra. Paula Fernandes', 'CRO-45678', 'Implantodontia', '(11) 94567-8901');

INSERT INTO Dentista (ID_Dentista, Nome, CRO, Especialidade, Telefone)
VALUES (seq_dentista.NEXTVAL, 'Dr. Ricardo Almeida', 'CRO-56789', 'Periodontia', '(11) 95678-9012');

-- Inserir 5 registros na tabela Consulta
INSERT INTO Consulta (ID_Consulta, Data_Consulta, ID_Paciente, ID_Dentista, Status)
VALUES (seq_consulta.NEXTVAL, TIMESTAMP '2024-10-20 10:30:00', 1, 1, 'Agendada');

INSERT INTO Consulta (ID_Consulta, Data_Consulta, ID_Paciente, ID_Dentista, Status)
VALUES (seq_consulta.NEXTVAL, TIMESTAMP '2024-10-21 15:00:00', 2, 2, 'Concluída');

INSERT INTO Consulta (ID_Consulta, Data_Consulta, ID_Paciente, ID_Dentista, Status)
VALUES (seq_consulta.NEXTVAL, TIMESTAMP '2024-10-22 09:00:00', 3, 3, 'Cancelada');

INSERT INTO Consulta (ID_Consulta, Data_Consulta, ID_Paciente, ID_Dentista, Status)
VALUES (seq_consulta.NEXTVAL, TIMESTAMP '2024-10-23 14:30:00', 4, 4, 'Agendada');

INSERT INTO Consulta (ID_Consulta, Data_Consulta, ID_Paciente, ID_Dentista, Status)
VALUES (seq_consulta.NEXTVAL, TIMESTAMP '2024-10-24 11:00:00', 5, 5, 'Concluída');

-- Inserir 5 registros na tabela HistoricoConsulta
INSERT INTO HistoricoConsulta (ID_Historico, ID_Consulta, Data_Atendimento, Motivo_Consulta, Observacoes)
VALUES (seq_historico.NEXTVAL, 1, TIMESTAMP '2024-10-20 10:30:00', 'Check-up geral', 'Paciente sem anormalidades.');

INSERT INTO HistoricoConsulta (ID_Historico, ID_Consulta, Data_Atendimento, Motivo_Consulta, Observacoes)
VALUES (seq_historico.NEXTVAL, 2, TIMESTAMP '2024-10-21 15:00:00', 'Dor de dente', 'Tratamento de canal realizado.');

INSERT INTO HistoricoConsulta (ID_Historico, ID_Consulta, Data_Atendimento, Motivo_Consulta, Observacoes)
VALUES (seq_historico.NEXTVAL, 3, TIMESTAMP '2024-10-22 09:00:00', 'Consulta cancelada', NULL);

INSERT INTO HistoricoConsulta (ID_Historico, ID_Consulta, Data_Atendimento, Motivo_Consulta, Observacoes)
VALUES (seq_historico.NEXTVAL, 4, TIMESTAMP '2024-10-23 14:30:00', 'Implante dentário', 'Paciente será acompanhado no pós-operatório.');

INSERT INTO HistoricoConsulta (ID_Historico, ID_Consulta, Data_Atendimento, Motivo_Consulta, Observacoes)
VALUES (seq_historico.NEXTVAL, 5, TIMESTAMP '2024-10-24 11:00:00', 'Limpeza', 'Paciente orientado sobre cuidados diários.');

Select * From Paciente;
Select * From Dentista;
Select * From Consulta;
Select * From HistoricoConsulta;