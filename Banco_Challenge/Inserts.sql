EXECUTE Insert_PACIENTE('Paulo', DATE '2000-12-12', '123.662.444-70', 'Rua Raimundico, 124', '(11) 66121-2322', 71111);
EXECUTE Insert_PACIENTE('Ana Silva', DATE '1995-05-20', '987.654.321-00', 'Av. Brasil, 456', '(11) 91234-5678', 72222);
EXECUTE Insert_PACIENTE('Carlos Souza', DATE '1988-08-30', '111.222.333-44', 'Rua das Flores, 78', '(21) 99876-5432', 73333);
EXECUTE Insert_PACIENTE('Fernanda Lima', DATE '1992-03-15', '222.333.444-55', 'Pça da Liberdade, 9', '(31) 93333-4444', 74444);
EXECUTE Insert_PACIENTE('Ricardo Oliveira', DATE '1985-11-10', '333.444.555-66', 'Rua dos Navegantes, 21', '(41) 94444-5555', 75555);

EXECUTE Insert_Dentista('Dr. Martin', 'CRO-13322', 'IMPLANTODONTIA', '(11) 1551-1491');
EXECUTE Insert_Dentista('Dr. João', 'CRO-14444', 'ORTODONTIA', '(11) 1234-5678');
EXECUTE Insert_Dentista('Dra. Luciana', 'CRO-15555', 'ENDODONTIA', '(21) 8765-4321');
EXECUTE Insert_Dentista('Dr. Pedro', 'CRO-16666', 'CIRURGIA', '(31) 9876-5432');
EXECUTE Insert_Dentista('Dra. Mariana', 'CRO-17777', 'ODONTOLOGIA ESTÉTICA', '(41) 9999-8888');

EXECUTE Insert_Consulta(TIMESTAMP '2024-10-24 12:30:00', 1, 2, 'cancelada');
EXECUTE Insert_Consulta(TIMESTAMP '2024-10-25 09:00:00', 2, 1, 'CONCLUIDA')
EXECUTE Insert_Consulta(TIMESTAMP '2024-10-26 10:00:00', 1, 3, 'agendada');
EXECUTE Insert_Consulta(TIMESTAMP '2024-10-27 14:30:00', 2, 3, 'concluida');
EXECUTE Insert_Consulta(TIMESTAMP '2024-10-28 16:00:00', 3, 1, 'cancelada');

EXECUTE Insert_HistoricoConsulta(1, TIMESTAMP '2024-10-24 12:30:00', 'Reconstrução', 'Paciente orientado sobre cuidados diários.');
EXECUTE Insert_HistoricoConsulta(2, TIMESTAMP '2024-10-25 09:30:00', 'Consulta de rotina', 'Paciente retornou bem.');
EXECUTE Insert_HistoricoConsulta(3, TIMESTAMP '2024-10-26 10:30:00', 'Avaliação de ortodontia', 'Pacientes com aparelho.');
EXECUTE Insert_HistoricoConsulta(4, TIMESTAMP '2024-10-27 15:00:00', 'Extração de dente', '');
EXECUTE Insert_HistoricoConsulta(5, TIMESTAMP '2024-10-28 17:00:00', 'Consulta de emergência', 'Paciente com dor aguda.');

