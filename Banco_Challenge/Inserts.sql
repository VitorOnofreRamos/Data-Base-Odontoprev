set SERVEROUT on;

-- Pacientes
EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('Paulo Silva', DATE '2000-12-12', '123.662.444-70', 'Rua Raimundico, 124', '(11) 66121-2322', 71111);
EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('Ana Silva', DATE '1995-05-20', '987.654.321-00', 'Av. Brasil, 456', '(11) 91234-5678', 72222);
EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('Carlos Souza', DATE '1988-08-30', '111.222.333-44', 'Rua das Flores, 78', '(21) 99876-5432', 73333);
EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('Fernanda Lima', DATE '1992-03-15', '222.333.444-55', 'Pça da Liberdade, 9', '(31) 93333-4444', 74444);
EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('Ricardo Oliveira', DATE '1985-11-10', '333.444.555-66', 'Rua dos Navegantes, 21', '(41) 94444-5555', 75555);
-- Pacientes sem Consulta atribuida
EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('João da Silva', DATE '1990-05-20', '123.456.789-01', 'Rua Almirante Prata, 123', '(11) 98888-7777', 10001);
EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('Maria Oliveira', DATE '1985-10-15', '234.567.890-12', 'Av. Bolacha, 34', '(11) 97777-6666', 10002);
EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('Carlos Souza', DATE '1992-03-10', '345.678.901-23', 'Rua Continente Novo, 789', '(11) 96666-5555', 10003);
EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('Ana Ferreira', DATE '1978-07-22', '456.789.012-34', 'Rua Dr Rocha, 101', '(11) 95555-4444', 10004);
EXECUTE pkg_procedures_crud_odontoprev.Insert_PACIENTE('Pedro Martins', DATE '2000-01-05', '567.890.123-45', 'Rua Excelência, 202', '(11) 94444-3333', 10005);

-- Dentistas
EXECUTE pkg_procedures_crud_odontoprev.Insert_Dentista('Dr. Martin Campos', 'CRO-13322', 'IMPLANTODONTIA', '(11) 1551-1491');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Dentista('Dr. João Barro', 'CRO-14444', 'ORTODONTIA', '(11) 1234-5678');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Dentista('Dra. Luciana da Silva', 'CRO-15555', 'ENDODONTIA', '(21) 8765-4321');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Dentista('Dr. Pedro Henrique', 'CRO-16666', 'CIRURGIA', '(31) 9876-5432');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Dentista('Dra. Mariana Bezerra', 'CRO-17777', 'ODONTOLOGIA ESTÉTICA', '(41) 9999-8888');
-- Dentistas sem Consulta atribuida
EXECUTE pkg_procedures_crud_odontoprev.Insert_Dentista('Dr. Eduardo Lima', 'CRO-12345', 'Ortodontia', '(11) 91234-5678');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Dentista('Dra. Juliana Souza', 'CRO-23456', 'Endodontia', '(11) 92345-6789');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Dentista('Dr. Marcos Santos', 'CRO-34567', 'Cirurgia', '(11) 93456-7890');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Dentista('Dra. Paula Fernandes', 'CRO-45678', 'Implantodontia', '(11) 94567-8901');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Dentista('Dr. Ricardo Almeida', 'CRO-56789', 'Periodontia', '(11) 95678-9012');

-- Consultas
EXECUTE pkg_procedures_crud_odontoprev.Insert_Consulta(TIMESTAMP '2024-10-24 12:30:00', 1, 2, 'cancelada');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Consulta(TIMESTAMP '2024-10-25 09:00:00', 2, 1, 'CONCLUIDA')
EXECUTE pkg_procedures_crud_odontoprev.Insert_Consulta(TIMESTAMP '2024-10-26 10:00:00', 1, 3, 'agendada');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Consulta(TIMESTAMP '2024-10-27 14:30:00', 2, 3, 'concluida');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Consulta(TIMESTAMP '2024-10-28 16:00:00', 3, 1, 'cancelada');

-- Histórico de Consultas
EXECUTE pkg_procedures_crud_odontoprev.Insert_Historico_Consulta(1, TIMESTAMP '2024-10-24 12:30:00', 'Reconstrução', 'Paciente orientado sobre cuidados diários.');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Historico_Consulta(2, TIMESTAMP '2024-10-25 09:30:00', 'Consulta de rotina', 'Paciente retornou bem.');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Historico_Consulta(3, TIMESTAMP '2024-10-26 10:30:00', 'Avaliação de ortodontia', 'Pacientes com aparelho.');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Historico_Consulta(4, TIMESTAMP '2024-10-27 15:00:00', 'Extração de dente', '');
EXECUTE pkg_procedures_crud_odontoprev.Insert_Historico_Consulta(5, TIMESTAMP '2024-10-28 17:00:00', 'Consulta de emergência', 'Paciente com dor aguda.');
