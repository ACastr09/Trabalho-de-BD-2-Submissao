PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

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
    (5, 'Cuidados Paliativos'),
    (6, 'Imagiologia');

INSERT INTO MedicoEspecialidade (Medico, Especialidade) VALUES
    ('M101', 1),
    ('M102', 2),
    ('M102', 1),
    ('M103', 3),
    ('M101', 5),
    ('M103', 4),
    ('M103', 6);

INSERT INTO EnfermeiroEspecialidade (Enfermeiro, Especialidade) VALUES
    ('E201', 5),
    ('E202', 5),
    ('E202', 4),
    ('E203', 5),
    ('E201', 1),
    ('E202', 2),
    ('E203', 3),
    ('E203', 6);

INSERT INTO Utente (idUtente, sns, nome, dataNascimento, genero, contacto, historicoClinico) VALUES
    (1, '145896321', 'Carlos Martins', '1978-03-14', 'Masculino', '910000000', 'Hipertensão arterial controlada.'),
    (2, '236985412', 'Sofia Oliveira', '1993-11-05', 'Feminino', '960000000', NULL),
    (3, '109874523', 'António Pereira', '1957-07-22', 'Masculino', '930000000', 'Diabetes tipo 2 e asma ligeira.'),
    (4, '000000004', 'Inês Martins', '1987-02-12', 'Feminino', '910000000', NULL);

INSERT INTO Internamento (idInternamento, dataHoraEntrada, dataHoraAlta, motivoAdmissao, Utente) VALUES
    (1, '2026-11-01 08:30:00', '2026-11-04 16:00:00', 'Febre persistente e tosse há 4 dias.', 1),
    (2, '2026-11-02 10:15:00', '2026-11-05 11:30:00', 'Episódio de falta de ar acentuada.', 2),
    (3, '2026-11-06 14:20:00', NULL, 'Descompensação respiratória para vigilância.', 3),
    (4, '2026-11-12 09:00:00', '2026-11-13 15:00:00', 'Reavaliação por persistência de sintomas.', 1);

INSERT INTO RegistoSinaisVitais (Internamento, dataRegisto, pressaoArterial, escalaDor, saturacaoO2, temperatura, frequenciaCardiaca, Enfermeiro) VALUES
    (1, '2026-11-01 08:45:00', '132/84', 4, 95, 38.4, 92, 'E201'),
    (1, '2026-11-04 15:00:00', '124/78', 0, 98, 36.6, 74, 'E202'),
    (2, '2026-11-02 10:30:00', '118/76', 3, 93, 37.1, 98, 'E202'),
    (3, '2026-11-06 14:40:00', '145/88', 5, 91, 37.8, 102, 'E203'),
    (2, '2026-11-04 16:00:00', '120/78', 0, 100, 36.7, 78, 'E201'),
    (3, '2026-11-07 09:00:00', '140/85', 4, 94, 37.3, 90, 'E203'),
    (4, '2026-11-12 09:00:00', '128/80', 10, 98, 36.8, 88, 'E202');

INSERT INTO Sintoma (idSintoma, nome) VALUES
    (1, 'Febre'),
    (2, 'Tosse produtiva'),
    (3, 'Falta de ar'),
    (4, 'Dor torácica'),
    (5, 'Irritação da pele');

INSERT INTO Diagnostico (idDiagnostico, descricao, Utente, Medico) VALUES
    (1, 'Pneumonia adquirida na comunidade', 1, 'M101'),
    (2, 'Crise asmática moderada', 2, 'M102'),
    (3, 'Bronquite aguda', 3, 'M101'),
    (4, 'Irritação cutânea superficial', 1, 'M103'),
    (5, 'Dor torácica em avaliação ambulatória', 4, 'M103');

INSERT INTO InternamentoDiagnostico (Internamento, Diagnostico) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 1),
    (4, 4);

INSERT INTO DiagnosticoSintoma (Diagnostico, Sintoma, dataDiagnostico) VALUES
    (1, 1, '2026-11-01 10:00:00'),
    (1, 2, '2026-11-01 10:00:00'),
    (2, 3, '2026-11-02 11:15:00'),
    (3, 3, '2026-11-06 16:00:00'),
    (3, 4, '2026-11-06 16:00:00'),
    (4, 5, '2026-11-12 10:00:00'),
    (5, 4, '2026-11-10 14:15:00');

INSERT INTO Prescricao (idPrescricao, dataInicio, dataFim, Diagnostico, Medico) VALUES
    (1, '2026-11-01 11:00:00', '2026-11-04 16:00:00', 1, 'M101'),
    (2, '2026-11-01 11:00:00', '2026-11-03 18:00:00', 1, 'M101'),
    (3, '2026-11-02 09:00:00', '2026-11-02 09:30:00', 1, 'M102'),
    (4, '2026-11-02 12:00:00', '2026-11-05 11:00:00', 2, 'M102'),
    (5, '2026-11-03 10:00:00', '2026-11-05 10:00:00', 2, 'M102'),
    (6, '2026-11-06 17:00:00', NULL, 3, 'M101'),
    (7, '2026-11-12 11:00:00', '2026-11-13 12:00:00', 4, 'M103'),
    (8, '2026-11-12 11:30:00', '2026-11-12 14:00:00', 1, 'M102'),
    (9, '2026-11-12 12:00:00', '2026-11-12 15:00:00', 1, 'M101'),
    (10, '2026-11-12 14:00:00', '2026-11-12 14:00:00', 1, 'M102'),
    (11, '2026-11-12 14:30:00', '2026-11-13 12:00:00', 1, 'M102'),
    (12, '2026-11-12 12:10:00', '2026-11-13 12:00:00', 1, 'M101');

INSERT INTO PrMedicamento (Prescricao, numeroMedicamentos, posologia) VALUES
    (1, 2, 'Amoxicilina de 8 em 8 horas; Paracetamol em caso de febre ou dor, max 3 por dia.'),
    (4, 1, '2 inalações de 6 em 6 horas.'),
    (6, 1, 'Meio comprimido de 12 em 12 horas.'),
    (7, 1, 'Aplicação local registada no plano do episódio.'),
    (8, 1, 'Administração única registada no episódio.');

INSERT INTO PrAnalise (Prescricao, nome, tipo) VALUES
    (2, 'Hemograma completo', 'Sangue'),
    (9, 'Estudo microbiológico', 'Urina'),
    (12, 'Estudo microbiológico', 'Sangue');

INSERT INTO PrTerapia (Prescricao, nome, Especialidade) VALUES
    (5, 'Fisioterapia respiratória', 4),
    (11, 'Fisioterapia respiratória', 2);

INSERT INTO PrExame (Prescricao, nome, Especialidade) VALUES
    (3, 'Raio-X ao tórax', 6),
    (10, 'Raio-X ao tórax', 2);

INSERT INTO Medicamento (idMedicamento, principioAtivo) VALUES
    (1, 'Amoxicilina + Ácido Clavulânico'),
    (2, 'Paracetamol'),
    (3, 'Salbutamol'),
    (4, 'Trolamina'),
    (5, 'Paracetamol');

INSERT INTO ViaAdministracao (idVia, nome) VALUES
    (1, 'Oral'),
    (2, 'Inalatória'),
    (3, 'Intravenosa'),
    (4, 'Tópica');

INSERT INTO Dosagem (Prescricao, Medicamento, quantidade) VALUES
    (1, 1, '1 comprimido (875mg + 125mg)'),
    (1, 2, '1 comprimido (1000mg)'),
    (4, 3, '2 inalações (100mcg/dose)'),
    (6, 2, '0.5 comprimido (500mg)'),
    (7, 4, '1 aplicação'),
    (8, 5, '1 unidade de apresentação');

INSERT INTO Administracao (idAdministracao, dataAdministracao, lote, Via, Enfermeiro, Medicamento) VALUES
    (1, '2026-11-01 11:00:00', 'AMX26A12', 1, 'E201', 1),
    (2, '2026-11-01 19:00:00', 'AMX26A12', 1, 'E202', 1),
    (3, '2026-11-02 08:30:00', 'PAR26B04', 1, 'E201', 2),
    (4, '2026-11-02 12:00:00', 'SLB25C98', 2, 'E202', 3),
    (5, '2026-11-06 17:05:00', 'PAR26B04', 1, 'E203', 2),
    (6, '2026-11-12 11:10:00', 'L26C', 4, 'E202', 4),
    (7, '2026-11-12 11:50:00', 'L26C', 3, 'E201', 5);

INSERT INTO ColheitaDeAnalise (idColheita, dataHoraEfetiva, Analise, Enfermeiro) VALUES
    (1, '2026-11-01 11:10:00', 2, 'E201'),
    (2, '2026-11-03 08:00:00', 2, 'E202'),
    (3, '2026-11-12 12:15:00', 9, 'E203'),
    (4, '2026-11-12 16:00:00', 12, 'E202');

COMMIT;
