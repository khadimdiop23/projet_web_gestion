
db = db.getSiblingDB('transports_urbains');

db.stations.insertMany([
    {
        _id: 1,
        nom: "Gare Centre",
        commune: "Rouen",
        location: {
            type: "Point",
            coordinates: [1.0993, 49.4431] 
        },
        lignes_qui_desservent: [1, 2] 
    },
    {
        _id: 2,
        nom: "Hotel de Ville",
        commune: "Rouen",
        location: {
            type: "Point",
            coordinates: [1.1001, 49.4425]
        },
        lignes_qui_desservent: [1]
    },
    {
        _id: 3,
        nom: "Universite",
        commune: "Mont-Saint-Aignan",
        location: {
            type: "Point",
            coordinates: [1.0683, 49.4580]
        },
        lignes_qui_desservent: [2]
    }
]);


db.lignes.insertMany([
    {
        _id: 1,
        nom: "T1",
        type: "Tram",
        couleur: "#FF0000",
        horaires: [
            {
                station_id: 1,
                station_nom: "Gare Centre",
                timestamp: new ISODate("2025-02-19T07:30:00Z"),
                direction: "Nord"
            },
            {
                station_id: 2,
                station_nom: "Hotel de Ville",
                timestamp: new ISODate("2025-02-19T07:33:00Z"),
                direction: "Nord"
            },
            {
                station_id: 1,
                station_nom: "Gare Centre",
                timestamp: new ISODate("2025-02-19T08:00:00Z"),
                direction: "Sud"
            },
            {
                station_id: 2,
                station_nom: "Hotel de Ville",
                timestamp: new ISODate("2025-02-19T08:03:00Z"),
                direction: "Sud"
            }
        ],
        stations_ids: [1, 2],
        frequence_matin: "10 min",
        frequence_soir: "15 min"
    },
    {
        _id: 2,
        nom: "F2",
        type: "Bus Rapide",
        couleur: "#0000FF",
        horaires: [
            {
                station_id: 1,
                station_nom: "Gare Centre",
                timestamp: new ISODate("2025-02-19T07:45:00Z"),
                direction: "Est"
            },
            {
                station_id: 3,
                station_nom: "Universite",
                timestamp: new ISODate("2025-02-19T07:55:00Z"),
                direction: "Est"
            }
        ],
        stations_ids: [1, 3],
        frequence_matin: "15 min",
        frequence_soir: "20 min"
    }
]);


db.vehicules.insertMany([
    {
        _id: "BUS001",
        modele: "Iveco Urbanway",
        capacite: 110,
        annee_mise_en_service: 2022,
        lignes_affectees: [2],
        etat: "En service",
        derniere_maintenance: new ISODate("2025-01-15T00:00:00Z")
    },
    {
        _id: "TRAM021",
        modele: "Alstom Citadis",
        capacite: 220,
        annee_mise_en_service: 2020,
        lignes_affectees: [1],
        etat: "En service",
        derniere_maintenance: new ISODate("2025-02-01T00:00:00Z")
    },
    {
        _id: "BUS002",
        modele: "Mercedes Citaro",
        capacite: 120,
        annee_mise_en_service: 2023,
        lignes_affectees: [2],
        etat: "En service",
        derniere_maintenance: new ISODate("2025-01-20T00:00:00Z")
    }
]);


db.lignes.createIndex({ "horaires.timestamp": 1 });
db.lignes.createIndex({ "horaires.station_id": 1 });
db.lignes.createIndex({ nom: 1 });
db.stations.createIndex({ location: "2dsphere" });
db.stations.createIndex({ "lignes_qui_desservent": 1 });
db.vehicules.createIndex({ "lignes_affectees": 1 });

print("Import MongoDB terminé avec succès !");
print(db.stations.countDocuments() + " stations importées");
print(db.lignes.countDocuments() + " lignes importées");
print(db.vehicules.countDocuments() + " véhicules importés");