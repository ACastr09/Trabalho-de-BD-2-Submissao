PRAGMA foreign_keys = ON;

INSERT INTO Profissional (numeroMecanografico, nome, nif, contacto, nivelQualificacaoAcademica) VALUES
    ('M101', 'João Ferreira', '215489320', '910000000', 'Mestrado'),
    ('M102', 'Mariana Costa', '238914502', '960000000', 'Mestrado'),
    ('M103', 'Rui Almeida', '198456213', '930000000', 'Doutoramento'),
    ('E201', 'Ana Silva', '245612398', '910000000', 'Licenciatura'),
    ('E202', 'Tiago Mendes', '251987430', '960000000', 'Mestrado'),
    ('E203', 'Beatriz Rocha', '264123985', '930000000', 'Licenciatura');

INSERT INTO Medico (numMec, numCedula) VALUES
    ('M101', '54821'),
    ('M102', '61204'),
    ('M103', '43915');

INSERT INTO Enfermeiro (numMec, numOrdem) VALUES
    ('E201', '78412'),
    ('E202', '81530'),
    ('E203', '90241');

INSERT INTO Especialidade (idEspecialidade, nome) VALUES
    (1, 'Medicina Interna'),
    (2, 'Pneumologia'),
    (3, 'Cardiologia'),
    (4, 'Reabilitação'),
    (5, 'Enfermagem Geral'),
    (6, 'Imagiologia');

INSERT INTO MedicoEspecialidade (Medico, Especialidade) VALUES
    ('M101', 1),
    ('M102', 2),
    ('M102', 1),
    ('M103', 3);

INSERT INTO EnfermeiroEspecialidade (Enfermeiro, Especialidade) VALUES
    ('E201', 5),
    ('E202', 5),
    ('E202', 4),
    ('E203', 5);

INSERT INTO Utente (idUtente, sns, nome, dataNascimento, genero, contacto, historicoClinico) VALUES
    (1, '145896321', 'Carlos Martins', '1978-03-14', 'Masculino', '910000000', 'Hipertensão arterial controlada.'),
    (2, '236985412', 'Sofia Oliveira', '1993-11-05', 'Feminino', '960000000', NULL),
    (3, '109874523', 'António Pereira', '1957-07-22', 'Masculino', '930000000', 'Diabetes tipo 2 e asma ligeira.');

INSERT INTO Internamento (idInternamento, dataHoraEntrada, dataHoraAlta, motivoAdmissao, Utente) VALUES
    (1, '2026-11-01 08:30:00', '2026-11-04 16:00:00', 'Febre persistente e tosse há 4 dias.', 1),
    (2, '2026-11-02 10:15:00', '2026-11-05 11:30:00', 'Episódio de falta de ar acentuada.', 2),
    (3, '2026-11-06 14:20:00', NULL, 'Descompensação respiratória para vigilância.', 3);

INSERT INTO RegistoSinaisVitais (Internamento, dataRegisto, pressaoArterial, escalaDor, saturacaoO2, temperatura, frequenciaCardiaca, Enfermeiro) VALUES
    (1, '2026-11-01 08:45:00', '132/84', 4, 95, 38.4, 92, 'E201'),
    (1, '2026-11-04 15:00:00', '124/78', 0, 98, 36.6, 74, 'E202'),
    (2, '2026-11-02 10:30:00', '118/76', 3, 93, 37.1, 98, 'E202'),
    (3, '2026-11-06 14:40:00', '145/88', 5, 91, 37.8, 102, 'E203');

INSERT INTO Sintoma (idSintoma, nome) VALUES (1, 'Febre');
INSERT INTO Sintoma (idSintoma, nome) VALUES (2, 'Tosse produtiva');
INSERT INTO Sintoma (idSintoma, nome) VALUES (3, 'Falta de ar');
INSERT INTO Sintoma (idSintoma, nome) VALUES (4, 'Dor torácica');

INSERT INTO Diagnostico (idDiagnostico, descricao, Utente, Medico) VALUES
    (1, 'Pneumonia adquirida na comunidade', 1, 'M101'),
    (2, 'Crise asmática moderada', 2, 'M102'),
    (3, 'Bronquite aguda', 3, 'M101');

INSERT INTO InternamentoDiagnostico (Internamento, Diagnostico) VALUES
    (1, 1),
    (2, 2),
    (3, 3);

INSERT INTO DiagnosticoSintoma (Diagnostico, Sintoma, dataDiagnostico) VALUES
    (1, 1, '2026-11-01 10:00:00'),
    (1, 2, '2026-11-01 10:00:00'),
    (2, 3, '2026-11-02 11:15:00'),
    (3, 3, '2026-11-06 16:00:00'),
    (3, 4, '2026-11-06 16:00:00');

INSERT INTO Prescricao (idPrescricao, dataInicio, dataFim, Diagnostico, Medico) VALUES
    (1, '2026-11-01 11:00:00', '2026-11-04 16:00:00', 1, 'M101'),
    (2, '2026-11-01 11:00:00', '2026-11-03 18:00:00', 1, 'M101'),
    (3, '2026-11-02 09:00:00', '2026-11-02 09:30:00', 1, 'M102'),
    (4, '2026-11-02 12:00:00', '2026-11-05 11:00:00', 2, 'M102'),
    (5, '2026-11-03 10:00:00', '2026-11-05 10:00:00', 2, 'M102'),
    (6, '2026-11-06 17:00:00', NULL, 3, 'M101');

INSERT INTO PrMedicamento (Prescricao, numeroMedicamentos, posologia) VALUES
    (1, 2, 'Amoxicilina de 8 em 8 horas; Paracetamol em caso de febre ou dor, max 3 por dia.'),
    (4, 1, '2 inalações de 6 em 6 horas.'),
    (6, 1, 'Meio comprimido de 12 em 12 horas.');

INSERT INTO PrAnalise (Prescricao, nome, tipo) VALUES
    (2, 'Hemograma completo', 'Sangue');

INSERT INTO PrTerapia (Prescricao, nome, Especialidade) VALUES
    (5, 'Fisioterapia respiratória', 4);

INSERT INTO PrExame (Prescricao, nome, Especialidade) VALUES
    (3, 'Raio-X ao tórax', 6);

INSERT INTO Medicamento (idMedicamento, principioAtivo) VALUES
    (1, 'Amoxicilina + Ácido Clavulânico'),
    (2, 'Paracetamol'),
    (3, 'Salbutamol'),
    (4, 'Trolamina');

INSERT INTO ViaAdministracao (idVia, nome) VALUES
    (1, 'Oral'),
    (2, 'Inalatória'),
    (3, 'Intravenosa'),
    (4, 'Topico');

INSERT INTO Dosagem (Prescricao, Medicamento, quantidade) VALUES
    (1, 1, '1 comprimido (875mg + 125mg)'),
    (1, 2, '1 comprimido (1000mg)'),
    (4, 3, '2 inalações (100mcg/dose)'),
    (6, 2, '0.5 comprimido (500mg)');

INSERT INTO Administracao (idAdministracao, dataAdministracao, lote, Via, Enfermeiro, Medicamento) VALUES
    (1, '2026-11-01 11:00:00', 'AMX26A12', 1, 'E201', 1),
    (2, '2026-11-01 19:00:00', 'AMX26A12', 1, 'E202', 1),
    (3, '2026-11-02 08:30:00', 'PAR26B04', 1, 'E201', 2),
    (4, '2026-11-02 12:00:00', 'SLB25C98', 2, 'E202', 3),
    (5, '2026-11-06 17:05:00', 'PAR26B04', 1, 'E203', 2);

INSERT INTO ColheitaDeAnalise (idColheita, dataHoraEfetiva, Analise, Enfermeiro) VALUES
    (1, '2026-11-01 11:10:00', 2, 'E201'),
    (2, '2026-11-03 08:00:00', 2, 'E202');