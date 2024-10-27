DROP TABLE Paciente cascade constraints;
DROP TABLE Dentista cascade constraints;
DROP TABLE Consulta cascade constraints;
DROP TABLE HistoricoConsulta cascade constraints;

DROP SEQUENCE seq_paciente;
DROP SEQUENCE seq_dentista;
DROP SEQUENCE seq_consulta;
DROP SEQUENCE seq_historico;


CREATE TABLE Paciente (
    ID_Paciente NUMBER(12) PRIMARY KEY,
    Nome VARCHAR2(30) NOT NULL,
    Data_Nascimento DATE NOT NULL,
    CPF VARCHAR2(14) UNIQUE NOT NULL,
    Endereco VARCHAR2(200) NOT NULL,
    Telefone VARCHAR2(20) NOT NULL,
    Carteirinha NUMBER(12) UNIQUE NOT NULL
);

CREATE TABLE Dentista (
    ID_Dentista NUMBER(12) PRIMARY KEY,
    Nome VARCHAR2(100) NOT NULL,
    CRO VARCHAR2(20) UNIQUE NOT NULL,
    Especialidade VARCHAR2(50) NOT NULL,
    Telefone VARCHAR2(20) NOT NULL
);

CREATE TABLE Consulta (
    ID_Consulta NUMBER(12) PRIMARY KEY,
    Data_Consulta TIMESTAMP NOT NULL,
    ID_Paciente NUMBER(12),
    ID_Dentista NUMBER(12),
    Status VARCHAR2(50) NOT NULL,
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente),
    FOREIGN KEY (ID_Dentista) REFERENCES Dentista(ID_Dentista)
);

CREATE TABLE HistoricoConsulta (
    ID_Historico NUMBER(12) PRIMARY KEY,
    ID_Consulta NUMBER(12),
    Data_Atendimento TIMESTAMP NOT NULL,
    Motivo_Consulta VARCHAR2(300) NOT NULL,
    Observacoes VARCHAR2(300),
    FOREIGN KEY (ID_Consulta) REFERENCES Consulta(ID_Consulta)
);

CREATE SEQUENCE seq_paciente START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_dentista START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_consulta START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_historico START WITH 1 INCREMENT BY 1;

