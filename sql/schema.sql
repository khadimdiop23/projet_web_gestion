

PRAGMA foreign_keys = ON;

-- Table stations
DROP TABLE IF EXISTS station;
CREATE TABLE station (
    id INTEGER PRIMARY KEY,
    nom TEXT NOT NULL,
    commune TEXT NOT NULL,
    latitude REAL NOT NULL,
    longitude REAL NOT NULL
);

-- Table lignes
DROP TABLE IF EXISTS ligne;
CREATE TABLE ligne (
    id INTEGER PRIMARY KEY,
    nom TEXT NOT NULL,
    type TEXT NOT NULL,
    couleur TEXT,
    frequence_matin TEXT,
    frequence_soir TEXT
);


DROP TABLE IF EXISTS vehicule;
CREATE TABLE vehicule (
    id TEXT PRIMARY KEY,
    modele TEXT NOT NULL,
    capacite INTEGER NOT NULL,
    annee_mise_en_service INTEGER,
    etat TEXT,
    derniere_maintenance TEXT
);

DROP TABLE IF EXISTS horaire;
CREATE TABLE horaire (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ligne_id INTEGER NOT NULL,
    station_id INTEGER NOT NULL,
    timestamp TEXT NOT NULL,
    direction TEXT,
    FOREIGN KEY (ligne_id) REFERENCES ligne(id),
    FOREIGN KEY (station_id) REFERENCES station(id)
);


CREATE INDEX IF NOT EXISTS idx_horaires_timestamp ON horaire(timestamp);
CREATE INDEX IF NOT EXISTS idx_horaires_station ON horaire(station_id);
CREATE INDEX IF NOT EXISTS idx_ligne_nom ON ligne(nom);
CREATE INDEX IF NOT EXISTS idx_vehicule_lignes ON vehicule(id);
