CREATE OR REPLACE PACKAGE Pkg_Procedures_Relatorios_Odontoprev AS
    PROCEDURE proc_relatorio_consultas;
    PROCEDURE proc_relatorio_auditoria;
END Pkg_Procedures_Relatorios_Odontoprev;
/

CREATE OR REPLACE PACKAGE BODY Pkg_Procedures_Relatorios_Odontoprev AS
/*
Procedure: proc_relatorio_consultas
Relt�rio com dados de Consulta, Paciente, Dentista e (opcionalmente) o Hist�rico da Consulta.
*/
  PROCEDURE proc_relatorio_consultas IS
    CURSOR c_relatorio IS
      SELECT 
        c.ID_Consulta,
        TO_CHAR(c.Data_Consulta, 'DD/MM/YYYY HH24:MI:SS') AS Data_Consulta,
        p.Nome AS Nome_Paciente,
        UPPER(d.Nome) AS Nome_Dentista,  -- Fun��o de tratamento: exibe o nome em caixa alta
        c.Status,
        NVL(hc.Motivo_Consulta, 'Sem Hist�rico') AS Motivo_Consulta,
        -- Fun��o de agrega��o: total de consultas realizadas pelo dentista
        (SELECT COUNT(*) FROM Consulta cc WHERE cc.ID_Dentista = d.ID_Dentista) AS Total_Consultas_Dentista
      FROM Consulta c
        INNER JOIN Paciente p ON c.ID_Paciente = p.ID_Paciente       -- INNER JOIN
        INNER JOIN Dentista d ON c.ID_Dentista = d.ID_Dentista          -- INNER JOIN
        LEFT JOIN Historico_Consulta hc ON c.ID_Consulta = hc.ID_Consulta -- LEFT JOIN para hist�rico opcional
      ORDER BY c.Data_Consulta;
    
    v_rel c_relatorio%ROWTYPE;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('===== Relat�rio de Consultas =====');
    FOR v_rel IN c_relatorio LOOP
      DBMS_OUTPUT.PUT_LINE('Consulta: ' || v_rel.ID_Consulta || 
                           ' | Data: ' || v_rel.Data_Consulta ||
                           ' | Paciente: ' || v_rel.Nome_Paciente ||
                           ' | Dentista: ' || v_rel.Nome_Dentista ||
                           ' | Status: ' || v_rel.Status ||
                           ' | Motivo: ' || v_rel.Motivo_Consulta ||
                           ' | Total Consultas do Dentista: ' || v_rel.Total_Consultas_Dentista);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro no relat�rio de consultas: ' || SQLERRM);
  END proc_relatorio_consultas;
  
/*
Procedure: proc_relatorio_auditoria
Relat�rio a partir da tabela de auditoria, exibindo dados detalhados e totalizando as opera��es agrupadas por tabela e tipo.
*/
  PROCEDURE proc_relatorio_auditoria IS
    CURSOR c_auditoria IS
      SELECT 
        a.ID_AUDITORIA,
        a.NOME_TABELA,
        a.TIPO_OPERACAO,
        TO_CHAR(a.DATA_HORA, 'DD/MM/YYYY HH24:MI:SS') AS Data_Hora,
        a.USUARIO,
        a.ID_REGISTRO,
        NVL(p.Nome, 'N/A') AS Nome_Paciente,
        -- Fun��o de agrega��o anal�tica: total de opera��es por Tabela e Tipo
        COUNT(*) OVER (PARTITION BY a.NOME_TABELA, a.TIPO_OPERACAO) AS Total_Operacoes
      FROM Auditoria_Odontoprev a
        LEFT JOIN Paciente p 
          ON (a.NOME_TABELA = 'Paciente' AND a.ID_REGISTRO = p.ID_Paciente)
      ORDER BY a.NOME_TABELA, a.TIPO_OPERACAO, a.DATA_HORA;
    
    v_aud c_auditoria%ROWTYPE;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('===== Relat�rio de Auditoria =====');
    FOR v_aud IN c_auditoria LOOP
      DBMS_OUTPUT.PUT_LINE('ID Auditoria: ' || v_aud.ID_AUDITORIA ||
                           ' | Tabela: ' || v_aud.NOME_TABELA ||
                           ' | Opera��o: ' || v_aud.TIPO_OPERACAO ||
                           ' | Data: ' || v_aud.Data_Hora ||
                           ' | Usu�rio: ' || v_aud.USUARIO ||
                           ' | ID Registro: ' || v_aud.ID_REGISTRO ||
                           ' | Nome Paciente: ' || v_aud.Nome_Paciente ||
                           ' | Total Opera��es: ' || v_aud.Total_Operacoes);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro no relat�rio de auditoria: ' || SQLERRM);
  END proc_relatorio_auditoria;

END Pkg_Procedures_Relatorios_Odontoprev;
/

set SERVEROUTPUT on;

EXECUTE Pkg_Procedures_Relatorios_Odontoprev.proc_relatorio_consultas;
EXECUTE Pkg_Procedures_Relatorios_Odontoprev.proc_relatorio_auditoria;