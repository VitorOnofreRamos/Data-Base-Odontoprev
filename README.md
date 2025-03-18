# Banco de Dados OdontoCare - Combate ao Sinistro

## Visão Geral
Este repositório contém o banco de dados Oracle utilizado nas aplicações mobile e web do projeto OdontoCare, desenvolvido em parceria com a Odontoprev para combater fraudes e sinistros em atendimentos odontológicos.

O banco de dados foi projetado para armazenar e gerenciar informações de pacientes, dentistas e consultas, garantindo a integridade e segurança dos dados.

## Estrutura do Projeto
O projeto está organizado da seguinte forma:

```
.
├── Banco_Challenge/ 
│   ├── Inserts.sql                             # Exução de várias Procedures para inserção de dados nas tabelas do banco.
│   ├── OdontoCare.sql                          # Script principal para criar e resetar o banco de dados (DROP TABLE/DROP SEQUENCE + CREATE TABLE/SEQUENCE).
│   ├── PkgFunAuxiliares.sql                    # Pakage com as Funções PL/SQL de validação simples.
│   ├── PkgFunValidacaoOdontoprev.sql           # Pakage com as Funções compostas para ajudar na validação dos métodos CRUD.
│   ├── PkgProcedureAuditoriaOdontoprev.sql     # Pakage com a Procedure de responsável por registrar operações em uma tabela de auditoria.
│   ├── PkgProceduresCRUDOdontoprev.sql         # Pakage com as Procedures para operações CRUD (Insert, Update, Delete, Read) com validações.
│   ├── PkgProceduresRelatoriosOdontoprev.sql   # Pakage com as Procedures para execução das regra de negócios (relatórios de consulta e auditoria).
│   ├── TriggerAuditoria.sql                    # Código PL/SQL implementa um sistema de auditoria para a base de dados do sistema OdontoCare.
```

## Estrutura das Tabelas
O banco de dados é composto pelas seguintes tabelas principais:

### Paciente
Armazena informações pessoais dos pacientes.
```sql
CREATE TABLE Paciente (
    ID_Paciente NUMBER(12) PRIMARY KEY,
    Nome VARCHAR2(30) NOT NULL,
    Data_Nascimento DATE NOT NULL,
    CPF VARCHAR2(14) UNIQUE NOT NULL,
    Endereco VARCHAR2(200) NOT NULL,
    Telefone VARCHAR2(20) NOT NULL,
    Carteirinha NUMBER(12) UNIQUE NOT NULL
);
```

### Dentista
Registra os profissionais da odontologia cadastrados no sistema.
```sql
CREATE TABLE Dentista (
    ID_Dentista NUMBER(12) PRIMARY KEY,
    Nome VARCHAR2(100) NOT NULL,
    CRO VARCHAR2(20) UNIQUE NOT NULL,
    Especialidade VARCHAR2(50) NOT NULL,
    Telefone VARCHAR2(20) NOT NULL
);
```

### Consulta
Controla os agendamentos realizados entre pacientes e dentistas.
```sql
CREATE TABLE Consulta (
    ID_Consulta NUMBER(12) PRIMARY KEY,
    Data_Consulta TIMESTAMP NOT NULL,
    ID_Paciente NUMBER(12) NOT NULL,
    ID_Dentista NUMBER(12) NOT NULL,
    Status VARCHAR2(50) NOT NULL,
    FOREIGN KEY (ID_Paciente) REFERENCES Paciente(ID_Paciente),
    FOREIGN KEY (ID_Dentista) REFERENCES Dentista(ID_Dentista)
);
```

### Histórico de Consulta
Armazena os atendimentos realizados em cada consulta.
```sql
CREATE TABLE Historico_Consulta (
    ID_Historico NUMBER(12) PRIMARY KEY,
    ID_Consulta NUMBER(12) NOT NULL,
    Data_Atendimento TIMESTAMP NOT NULL,
    Motivo_Consulta VARCHAR2(300) NOT NULL,
    Observacoes VARCHAR2(300),
    FOREIGN KEY (ID_Consulta) REFERENCES Consulta(ID_Consulta)
);
```

### Auditoria
Armazena todas as alterações feitas em tabelas do projeto.
```sql
CREATE TABLE Auditoria_Odontoprev (
    ID_AUDITORIA NUMBER PRIMARY KEY,
    NOME_TABELA VARCHAR2(50),
    ID_REGISTRO NUMBER,
    TIPO_OPERACAO VARCHAR2(10),
    DATA_HORA TIMESTAMP,
    USUARIO VARCHAR2(50),
    DADOS_ANTIGOS VARCHAR2(4000),
    DADOS_NOVOS VARCHAR2(4000)
);
```

## Funcionalidades
1. Funções de Validação de Entrada de Dados
  - Duas funções de validação garantem que os dados inseridos atendam aos critérios estabelecidos pelo sistema, evitando inconsistências.
2. Procedures CRUD
  - Procedures especializadas para operações INSERT, UPDATE e DELETE em cada tabela.
  - Validação automática dos dados antes da inserção e atualização.
  - Tratamento de erros e exceções para maior segurança e confiabilidade.
3. Execução via Aplicação Java
  - A aplicação backend em Java executa essas procedures diretamente, garantindo integração entre os serviços web/mobile e o banco de dados.
  - As operações realizadas incluem:
    - 2 INSERTs, 2 UPDATEs e 2 DELETEs para cada tabela selecionada.
  - Demonstração em vídeo disponível no repositório/documentação do projeto.
4. Geração de Relatórios
  - Uma função PL/SQL retorna uma tabela formatada contendo informações cruzadas entre pelo menos duas tabelas.
  - Inclui cursors, JOINs, ORDER BY, e funções agregadas como SUM e COUNT.
5. Controle de Alterações
  - A Tabela `Auditoria_Odontoprev` é utilizada para armazenar as mudanças feitas nas demais tabelas do projeto por meio de Triggers.

## Como Executar

1. Clone o repositório:
```bash
git clone https://github.com/VitorOnofreRamos/Data-Base-Odontoprev.git
cd Data-Base-Odontoprev/Banco_Challenge
```
2. Conecte-se ao Oracle Database
3. Execute os scripts na seguinte ordem:
  - `OdontoCare.sql` → Criação das tabelas e reset do banco.
  - `PkgFunAuxiliares.sql ` → Criação das funções de validação auxiliares.
  - `PkgFunValidacaoOdontoprev.sql ` → Criação das funções de validação das operções CRUD.
  - `PkgProceduresCRUDOdontoprev.sql ` → Procedures de manipulação de dados.
  - `PkgProcedureAuditoriaOdontoprev.sql` → Procedures para a tabela Auditoria.
  - `TriggerAuditoria.sql` → Triggers para ter processo de Auditoria.
  - `Inserts.sql` → Inserção inicial de dados *modelo* nas tabelas.
  - `PkgProceduresRelatoriosOdontoprev.sql` → Geração de relatórios das tabelas.

## Integrantes do grupo:
- Vitor Onofre Ramos
  - RM553241
- Pedro Henrique Soares Araujo:
  - RM553801
- Beatriz Silva:
  - RM552600
