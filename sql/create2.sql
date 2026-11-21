PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

DROP TABLE IF EXISTS ColheitaDeAnalise;
DROP TABLE IF EXISTS Administracao;
DROP TABLE IF EXISTS Dosagem;
DROP TABLE IF EXISTS ViaAdministracao;
DROP TABLE IF EXISTS Medicamento;
DROP TABLE IF EXISTS PrExame;
DROP TABLE IF EXISTS PrTerapia;
DROP TABLE IF EXISTS PrAnalise;
DROP TABLE IF EXISTS PrMedicamento;
DROP TABLE IF EXISTS Prescricao;
DROP TABLE IF EXISTS DiagnosticoSintoma;
DROP TABLE IF EXISTS InternamentoDiagnostico;
DROP TABLE IF EXISTS Diagnostico;
DROP TABLE IF EXISTS Sintoma;
DROP TABLE IF EXISTS RegistoSinaisVitais;
DROP TABLE IF EXISTS Internamento;
DROP TABLE IF EXISTS Utente;
DROP TABLE IF EXISTS EnfermeiroEspecialidade;
DROP TABLE IF EXISTS MedicoEspecialidade;
DROP TABLE IF EXISTS Especialidade;
DROP TABLE IF EXISTS Enfermeiro;
DROP TABLE IF EXISTS Medico;
DROP TABLE IF EXISTS Profissional;

-- As participações mínimas, a totalidade e a disjunção das subclasses,
-- a contagem de medicamentos e as regras entre datas de tabelas distintas
-- são verificadas nos dados do grupo. O esquema não usa triggers.

CREATE TABLE Profissional (
    numeroMecanografico TEXT NOT NULL PRIMARY KEY CHECK (length(trim(numeroMecanografico)) > 0),
    nome TEXT NOT NULL CHECK (length(trim(nome)) > 0),
    nif TEXT NOT NULL UNIQUE CHECK (length(nif) = 9 AND nif NOT GLOB '*[^0-9]*'),
    contacto TEXT NOT NULL CHECK (length(trim(contacto)) > 0),
    nivelQualificacaoAcademica TEXT NOT NULL CHECK (length(trim(nivelQualificacaoAcademica)) > 0)
);

CREATE TABLE Medico (
    numMec TEXT NOT NULL PRIMARY KEY,
    numCedula TEXT NOT NULL UNIQUE CHECK (length(trim(numCedula)) > 0),
    FOREIGN KEY (numMec) REFERENCES Profissional(numeroMecanografico)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Enfermeiro (
    numMec TEXT NOT NULL PRIMARY KEY,
    numOrdem TEXT NOT NULL UNIQUE CHECK (length(trim(numOrdem)) > 0),
    FOREIGN KEY (numMec) REFERENCES Profissional(numeroMecanografico)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Especialidade (
    idEspecialidade INTEGER PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE CHECK (length(trim(nome)) > 0)
);

CREATE TABLE MedicoEspecialidade (
    Medico TEXT NOT NULL,
    Especialidade INTEGER NOT NULL,
    PRIMARY KEY (Medico, Especialidade),
    FOREIGN KEY (Medico) REFERENCES Medico(numMec)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Especialidade) REFERENCES Especialidade(idEspecialidade)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE EnfermeiroEspecialidade (
    Enfermeiro TEXT NOT NULL,
    Especialidade INTEGER NOT NULL,
    PRIMARY KEY (Enfermeiro, Especialidade),
    FOREIGN KEY (Enfermeiro) REFERENCES Enfermeiro(numMec)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Especialidade) REFERENCES Especialidade(idEspecialidade)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Utente (
    idUtente INTEGER PRIMARY KEY,
    sns TEXT NOT NULL UNIQUE CHECK (length(sns) = 9 AND sns NOT GLOB '*[^0-9]*'),
    nome TEXT NOT NULL CHECK (length(trim(nome)) > 0),
    dataNascimento TEXT NOT NULL CHECK (
        dataNascimento GLOB '????-??-??'
        AND date(dataNascimento, '+0 days') IS dataNascimento
    ),
    genero TEXT NOT NULL CHECK (length(trim(genero)) > 0),
    contacto TEXT NOT NULL CHECK (length(trim(contacto)) > 0),
    historicoClinico TEXT
);

CREATE TABLE Internamento (
    idInternamento INTEGER PRIMARY KEY,
    dataHoraEntrada TEXT NOT NULL CHECK (
        dataHoraEntrada GLOB '????-??-?? ??:??:??'
        AND datetime(dataHoraEntrada, '+0 seconds') IS dataHoraEntrada
    ),
    dataHoraAlta TEXT CHECK (
        dataHoraAlta IS NULL OR (
            dataHoraAlta GLOB '????-??-?? ??:??:??'
            AND datetime(dataHoraAlta, '+0 seconds') IS dataHoraAlta
        )
    ),
    motivoAdmissao TEXT NOT NULL CHECK (length(trim(motivoAdmissao)) > 0),
    Utente INTEGER NOT NULL,
    CHECK (dataHoraAlta IS NULL OR dataHoraAlta >= dataHoraEntrada),
    FOREIGN KEY (Utente) REFERENCES Utente(idUtente)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE RegistoSinaisVitais (
    Internamento INTEGER NOT NULL,
    dataRegisto TEXT NOT NULL CHECK (
        dataRegisto GLOB '????-??-?? ??:??:??'
        AND datetime(dataRegisto, '+0 seconds') IS dataRegisto
    ),
    pressaoArterial TEXT NOT NULL CHECK (
        instr(pressaoArterial, '/') BETWEEN 2 AND 4
        AND length(pressaoArterial) - instr(pressaoArterial, '/') BETWEEN 1 AND 3
        AND substr(pressaoArterial, 1, instr(pressaoArterial, '/') - 1) NOT GLOB '*[^0-9]*'
        AND substr(pressaoArterial, instr(pressaoArterial, '/') + 1) NOT GLOB '*[^0-9]*'
    ),
    escalaDor INTEGER NOT NULL CHECK (typeof(escalaDor) = 'integer' AND escalaDor BETWEEN 0 AND 10),
    saturacaoO2 REAL NOT NULL CHECK (saturacaoO2 >= 0 AND saturacaoO2 <= 100),
    temperatura REAL NOT NULL CHECK (typeof(temperatura) IN ('integer', 'real')),
    frequenciaCardiaca INTEGER NOT NULL CHECK (typeof(frequenciaCardiaca) = 'integer' AND frequenciaCardiaca > 0),
    Enfermeiro TEXT NOT NULL,
    PRIMARY KEY (Internamento, dataRegisto),
    FOREIGN KEY (Internamento) REFERENCES Internamento(idInternamento)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Enfermeiro) REFERENCES Enfermeiro(numMec)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Sintoma (
    idSintoma INTEGER PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE CHECK (length(trim(nome)) > 0)
);

CREATE TABLE Diagnostico (
    idDiagnostico INTEGER PRIMARY KEY,
    descricao TEXT NOT NULL CHECK (length(trim(descricao)) > 0),
    Utente INTEGER NOT NULL,
    Medico TEXT NOT NULL,
    FOREIGN KEY (Utente) REFERENCES Utente(idUtente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Medico) REFERENCES Medico(numMec)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE InternamentoDiagnostico (
    Internamento INTEGER NOT NULL,
    Diagnostico INTEGER NOT NULL,
    PRIMARY KEY (Internamento, Diagnostico),
    FOREIGN KEY (Internamento) REFERENCES Internamento(idInternamento)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Diagnostico) REFERENCES Diagnostico(idDiagnostico)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE DiagnosticoSintoma (
    Diagnostico INTEGER NOT NULL,
    Sintoma INTEGER NOT NULL,
    dataDiagnostico TEXT NOT NULL CHECK (
        dataDiagnostico GLOB '????-??-?? ??:??:??'
        AND datetime(dataDiagnostico, '+0 seconds') IS dataDiagnostico
    ),
    PRIMARY KEY (Diagnostico, Sintoma),
    FOREIGN KEY (Diagnostico) REFERENCES Diagnostico(idDiagnostico)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Sintoma) REFERENCES Sintoma(idSintoma)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Prescricao (
    idPrescricao INTEGER PRIMARY KEY,
    dataInicio TEXT NOT NULL CHECK (
        dataInicio GLOB '????-??-?? ??:??:??'
        AND datetime(dataInicio, '+0 seconds') IS dataInicio
    ),
    dataFim TEXT CHECK (
        dataFim IS NULL OR (
            dataFim GLOB '????-??-?? ??:??:??'
            AND datetime(dataFim, '+0 seconds') IS dataFim
        )
    ),
    Diagnostico INTEGER NOT NULL,
    Medico TEXT NOT NULL,
    CHECK (dataFim IS NULL OR dataFim >= dataInicio),
    FOREIGN KEY (Diagnostico) REFERENCES Diagnostico(idDiagnostico)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Medico) REFERENCES Medico(numMec)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE PrMedicamento (
    Prescricao INTEGER PRIMARY KEY,
    numeroMedicamentos INTEGER NOT NULL CHECK (typeof(numeroMedicamentos) = 'integer' AND numeroMedicamentos > 0),
    posologia TEXT NOT NULL CHECK (length(trim(posologia)) > 0),
    FOREIGN KEY (Prescricao) REFERENCES Prescricao(idPrescricao)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PrAnalise (
    Prescricao INTEGER PRIMARY KEY,
    nome TEXT NOT NULL CHECK (length(trim(nome)) > 0),
    tipo TEXT NOT NULL CHECK (length(trim(tipo)) > 0),
    FOREIGN KEY (Prescricao) REFERENCES Prescricao(idPrescricao)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE PrTerapia (
    Prescricao INTEGER PRIMARY KEY,
    nome TEXT NOT NULL CHECK (length(trim(nome)) > 0),
    Especialidade INTEGER NOT NULL,
    FOREIGN KEY (Prescricao) REFERENCES Prescricao(idPrescricao)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Especialidade) REFERENCES Especialidade(idEspecialidade)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE PrExame (
    Prescricao INTEGER PRIMARY KEY,
    nome TEXT NOT NULL CHECK (length(trim(nome)) > 0),
    Especialidade INTEGER NOT NULL,
    FOREIGN KEY (Prescricao) REFERENCES Prescricao(idPrescricao)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Especialidade) REFERENCES Especialidade(idEspecialidade)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Medicamento (
    idMedicamento INTEGER PRIMARY KEY,
    principioAtivo TEXT NOT NULL CHECK (length(trim(principioAtivo)) > 0)
);

CREATE TABLE ViaAdministracao (
    idVia INTEGER PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE CHECK (length(trim(nome)) > 0)
);

CREATE TABLE Dosagem (
    Prescricao INTEGER NOT NULL,
    Medicamento INTEGER NOT NULL,
    quantidade TEXT NOT NULL CHECK (length(trim(quantidade)) > 0),
    PRIMARY KEY (Prescricao, Medicamento),
    FOREIGN KEY (Prescricao) REFERENCES PrMedicamento(Prescricao)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Medicamento) REFERENCES Medicamento(idMedicamento)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Administracao (
    idAdministracao INTEGER PRIMARY KEY,
    dataAdministracao TEXT NOT NULL CHECK (
        dataAdministracao GLOB '????-??-?? ??:??:??'
        AND datetime(dataAdministracao, '+0 seconds') IS dataAdministracao
    ),
    lote TEXT NOT NULL CHECK (length(trim(lote)) > 0),
    Via INTEGER NOT NULL,
    Enfermeiro TEXT NOT NULL,
    Medicamento INTEGER NOT NULL,
    FOREIGN KEY (Via) REFERENCES ViaAdministracao(idVia)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Enfermeiro) REFERENCES Enfermeiro(numMec)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Medicamento) REFERENCES Medicamento(idMedicamento)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ColheitaDeAnalise (
    idColheita INTEGER PRIMARY KEY,
    dataHoraEfetiva TEXT NOT NULL CHECK (
        dataHoraEfetiva GLOB '????-??-?? ??:??:??'
        AND datetime(dataHoraEfetiva, '+0 seconds') IS dataHoraEfetiva
    ),
    Analise INTEGER NOT NULL,
    Enfermeiro TEXT NOT NULL,
    FOREIGN KEY (Analise) REFERENCES PrAnalise(Prescricao)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (Enfermeiro) REFERENCES Enfermeiro(numMec)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

COMMIT;
