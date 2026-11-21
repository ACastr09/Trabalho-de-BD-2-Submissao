PRAGMA foreign_keys = ON;

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


CREATE TABLE Profissional (
    numeroMecanografico TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    nif TEXT NOT NULL UNIQUE,
    contacto TEXT NOT NULL,
    nivelQualificacaoAcademica TEXT NOT NULL
);

CREATE TABLE Medico (
    numMec TEXT PRIMARY KEY,
    numCedula TEXT NOT NULL UNIQUE,
    FOREIGN KEY (numMec) REFERENCES Profissional(numeroMecanografico)
);

CREATE TABLE Enfermeiro (
    numMec TEXT PRIMARY KEY,
    numOrdem TEXT NOT NULL UNIQUE,
    FOREIGN KEY (numMec) REFERENCES Profissional(numeroMecanografico)
);

CREATE TABLE Especialidade (
    idEspecialidade INTEGER PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE
);

CREATE TABLE MedicoEspecialidade (
    Medico TEXT NOT NULL,
    Especialidade INTEGER NOT NULL,
    PRIMARY KEY (Medico, Especialidade),
    FOREIGN KEY (Medico) REFERENCES Medico(numMec),
    FOREIGN KEY (Especialidade) REFERENCES Especialidade(idEspecialidade)
);

CREATE TABLE EnfermeiroEspecialidade (
    Enfermeiro TEXT NOT NULL,
    Especialidade INTEGER NOT NULL,
    PRIMARY KEY (Enfermeiro, Especialidade),
    FOREIGN KEY (Enfermeiro) REFERENCES Enfermeiro(numMec),
    FOREIGN KEY (Especialidade) REFERENCES Especialidade(idEspecialidade)
);


CREATE TABLE Utente (
    idUtente INTEGER PRIMARY KEY,
    sns TEXT NOT NULL UNIQUE,
    nome TEXT NOT NULL,
    dataNascimento TEXT NOT NULL,
    genero TEXT NOT NULL,
    contacto TEXT NOT NULL,
    historicoClinico TEXT
);

CREATE TABLE Internamento (
    idInternamento INTEGER PRIMARY KEY,
    dataHoraEntrada TEXT NOT NULL,
    dataHoraAlta TEXT,
    motivoAdmissao TEXT NOT NULL,
    Utente INTEGER NOT NULL,
    CHECK (dataHoraAlta IS NULL OR dataHoraAlta >= dataHoraEntrada),
    FOREIGN KEY (Utente) REFERENCES Utente(idUtente)
);

CREATE TABLE RegistoSinaisVitais (
    Internamento INTEGER NOT NULL,
    dataRegisto TEXT NOT NULL,
    pressaoArterial TEXT NOT NULL,
    escalaDor INTEGER NOT NULL CHECK (escalaDor >= 0 AND escalaDor <= 10),
    saturacaoO2 REAL NOT NULL CHECK (saturacaoO2 >= 0 AND saturacaoO2 <= 100),
    temperatura REAL NOT NULL,
    frequenciaCardiaca REAL NOT NULL CHECK (frequenciaCardiaca > 0),
    Enfermeiro TEXT NOT NULL,
    PRIMARY KEY (Internamento, dataRegisto),
    FOREIGN KEY (Internamento) REFERENCES Internamento(idInternamento),
    FOREIGN KEY (Enfermeiro) REFERENCES Enfermeiro(numMec)
);

CREATE TABLE Sintoma (
    idSintoma INTEGER PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE
);

CREATE TABLE Diagnostico (
    idDiagnostico INTEGER PRIMARY KEY,
    descricao TEXT NOT NULL,
    Utente INTEGER NOT NULL,
    Medico TEXT NOT NULL,
    FOREIGN KEY (Utente) REFERENCES Utente(idUtente),
    FOREIGN KEY (Medico) REFERENCES Medico(numMec)
);

CREATE TABLE InternamentoDiagnostico (
    Internamento INTEGER NOT NULL,
    Diagnostico INTEGER NOT NULL,
    PRIMARY KEY (Internamento, Diagnostico),
    FOREIGN KEY (Internamento) REFERENCES Internamento(idInternamento),
    FOREIGN KEY (Diagnostico) REFERENCES Diagnostico(idDiagnostico)
);

CREATE TABLE DiagnosticoSintoma (
    Diagnostico INTEGER NOT NULL,
    Sintoma INTEGER NOT NULL,
    dataDiagnostico TEXT NOT NULL,
    PRIMARY KEY (Diagnostico, Sintoma),
    FOREIGN KEY (Diagnostico) REFERENCES Diagnostico(idDiagnostico),
    FOREIGN KEY (Sintoma) REFERENCES Sintoma(idSintoma)
);

CREATE TABLE Prescricao (
    idPrescricao INTEGER PRIMARY KEY,
    dataInicio TEXT NOT NULL,
    dataFim TEXT,
    Diagnostico INTEGER NOT NULL,
    Medico TEXT NOT NULL,
    CHECK (dataFim IS NULL OR dataFim >= dataInicio),
    FOREIGN KEY (Diagnostico) REFERENCES Diagnostico(idDiagnostico),
    FOREIGN KEY (Medico) REFERENCES Medico(numMec)
);

CREATE TABLE PrMedicamento (
    Prescricao INTEGER PRIMARY KEY,
    numeroMedicamentos INTEGER NOT NULL CHECK (numeroMedicamentos > 0),
    posologia TEXT NOT NULL,
    FOREIGN KEY(Prescricao) REFERENCES Prescricao(idPrescricao)
);

CREATE TABLE PrAnalise (
    Prescricao INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    tipo TEXT NOT NULL,
    FOREIGN KEY(Prescricao) REFERENCES Prescricao(idPrescricao)
);

CREATE TABLE PrTerapia (
    Prescricao INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    Especialidade INTEGER NOT NULL,
    FOREIGN KEY (Prescricao) REFERENCES Prescricao(idPrescricao),
    FOREIGN KEY (Especialidade) REFERENCES Especialidade(idEspecialidade)
);

CREATE TABLE PrExame (
    Prescricao INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    Especialidade INTEGER NOT NULL,
    FOREIGN KEY (Prescricao) REFERENCES Prescricao(idPrescricao),
    FOREIGN KEY (Especialidade) REFERENCES Especialidade(idEspecialidade)
);

CREATE TABLE Medicamento (
    idMedicamento INTEGER PRIMARY KEY,
    principioAtivo TEXT NOT NULL
);

CREATE TABLE ViaAdministracao (
    idVia INTEGER PRIMARY KEY,
    nome TEXT NOT NULL UNIQUE
);

CREATE TABLE Dosagem (
    Prescricao INTEGER NOT NULL,
    Medicamento INTEGER NOT NULL,
    quantidade TEXT NOT NULL,
    PRIMARY KEY (Prescricao, Medicamento),
    FOREIGN KEY (Prescricao) REFERENCES PrMedicamento(Prescricao),
    FOREIGN KEY (Medicamento) REFERENCES Medicamento(idMedicamento)
);

CREATE TABLE Administracao (
    idAdministracao INTEGER PRIMARY KEY,
    dataAdministracao TEXT NOT NULL,
    lote TEXT NOT NULL,
    Via INTEGER NOT NULL,
    Enfermeiro TEXT NOT NULL,
    Medicamento INTEGER NOT NULL,
    FOREIGN KEY (Via) REFERENCES ViaAdministracao(idVia),
    FOREIGN KEY (Enfermeiro) REFERENCES Enfermeiro(numMec),
    FOREIGN KEY (Medicamento) REFERENCES Medicamento(idMedicamento)
);

CREATE TABLE ColheitaDeAnalise (
    idColheita INTEGER PRIMARY KEY,
    dataHoraEfetiva TEXT NOT NULL,
    Analise INTEGER NOT NULL,
    Enfermeiro TEXT NOT NULL,
    FOREIGN KEY (Analise) REFERENCES PrAnalise(Prescricao),
    FOREIGN KEY (Enfermeiro) REFERENCES Enfermeiro(numMec)
);