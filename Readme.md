# 1. Installer SQLite
sudo apt install sqlite3    # Ubuntu
brew install sqlite3        # macOS
choco install sqlite        # Windows

# 2. Installer MongoDB
sudo apt install mongodb    # Ubuntu/Debian
brew install mongodb-community  # macOS
choco install mongodb       # Windows

# 3. Installer xsltproc
sudo apt install xsltproc   # Ubuntu/Debian
brew install libxslt        # macOS

# Créer les tables
sqlite3 transports.db < sql/schema.sql

# Importer les stations
sqlite3 transports.db < sql/import_stations.sql
# Démarrer MongoDB
mongod --dbpath ./data/db

# Exécuter le script d'import
mongosh mongo/import.js
#  Gestion de Transports Urbains - Projet TP16

## Description du projet

Système d'information pour la gestion d'un réseau de transports urbains (bus/tram) incluant :
- Gestion des stations
- Gestion des lignes
- Gestion des horaires
- Gestion des véhicules

##  Structure du projet

```
PROJET_WEB]
├── sql/
│   ├── schema.sql             
│   ├── import_station.sql     
│   └── query.sql             
├── mongo/
│   ├── import.js               #
│   ├── query.js           
│   └── model.js              
├── xml/
│   ├── horaires.xml           
│   └── horaires.xslt           
├── data/
│   ├── stations.csv
│   ├── lignes.json
│   ├── vehicules.json
│   └── horaires.xml
└── README.md
```

### Prérequis

sqlite3+
MongoDB 6+
Python 3.8+ 
Node.js 18+ 

### Installation PostgreSQL

```bash
# Création de la base de données


### Installation MongoDB

```bash
# Connexion à MongoDB
mongosh

# Exécution du script d'import
mongosh < mongo/import.js


#### Schéma relationnel

```
STATION(id, nom, commune, latitude, longitude)
  PK: id

LIGNE(id, nom, type)
  PK: id
  UNIQUE: nom

VEHICULE(id, modele, capacite, ligne_id)
  PK: id
  FK: ligne_id → LIGNE(id)

HORAIRE(id, ligne_id, station_id, timestamp)
  PK: id
  FK: ligne_id → LIGNE(id)
  FK: station_id → STATION(id)
```

#### Justification 3FN

**1FN** : Toutes les colonnes contiennent des valeurs atomiques (pas de listes)

**2FN** : Pas de dépendance partielle
chaque attribut non-clé dépend de la totalité de la clé primaire
Exemple : dans HORAIRE, timestamp dépend de (ligne_id, station_id)
**3FN** : Pas de dépendance transitive
Aucun attribut non-clé ne dépend d'un autre attribut non-clé
Exemple : latitude/longitude dépendent uniquement de station.id, pas d'un autre attribut







## Partie 2 - Imports

### Import CSV (Nosql)

```bash
# Via COPY
sqlite  transport_urbain -c "COPY station(id, nom, commune, latitude, longitude) FROM '/path/to/stations.csv' "

# Via script
sqlite transport_urbain  sql/import_stations.sql
```

### Import JSON

**SQL (via script) :**
```bash
sqlite -d transport_urbain -f sql/import_stations.sql
```

**MongoDB :**
```bash
mongoimport --db transport_urbain --collection lignes --file data/lignes.json --jsonArray
mongosh < mongo/import.js
```



