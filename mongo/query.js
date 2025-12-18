

db = db.getSiblingDB('transports_urbains');

print("=== REQUÊTES MONGODB ===");

print("\n1. Tous les horaires de la ligne T1:");
const horairesLigneT1 = db.lignes.aggregate([
    { $match: { nom: "T1" } },
    { $unwind: "$horaires" },
    { $project: {
        _id: 0,
        ligne: "$nom",
        station: "$horaires.station_nom",
        heure: { $dateToString: { format: "%H:%M", date: "$horaires.timestamp" } },
        direction: "$horaires.direction",
        timestamp: "$horaires.timestamp"
    }},
    { $sort: { timestamp: 1 } }
]);
printjson(horairesLigneT1.toArray());


print("\n2. Horaires entre 7h00 et 9h00:");
const horairesMatin = db.lignes.aggregate([
    { $unwind: "$horaires" },
    { $match: {
        "horaires.timestamp": {
            $gte: ISODate("2025-02-19T07:00:00Z"),
            $lte: ISODate("2025-02-19T09:00:00Z")
        }
    }},
    { $project: {
        _id: 0,
        ligne: "$nom",
        type: "$type",
        station: "$horaires.station_nom",
        heure: { $dateToString: { format: "%H:%M", date: "$horaires.timestamp" } },
        direction: "$horaires.direction"
    }},
    { $sort: { "horaires.timestamp": 1 } }
]);
printjson(horairesMatin.toArray());


print("\n3. Lignes avec leur nombre de passages:");
const lignesAvecPassages = db.lignes.aggregate([
    {
        $project: {
            _id: 0,
            nom: 1,
            type: 1,
            nombre_passages: { $size: "$horaires" },
            nombre_stations: { $size: "$stations_ids" }
        }
    },
    { $sort: { nombre_passages: -1 } }
]);
printjson(lignesAvecPassages.toArray());


print("\n4. Stations desservies par chaque ligne:");
const stationsParLigne = db.lignes.aggregate([
    {
        $lookup: {
            from: "stations",
            localField: "stations_ids",
            foreignField: "_id",
            as: "stations_details"
        }
    },
    {
        $project: {
            _id: 0,
            ligne: "$nom",
            type: "$type",
            stations: {
                $map: {
                    input: "$stations_details",
                    as: "station",
                    in: {
                        nom: "$$station.nom",
                        commune: "$$station.commune"
                    }
                }
            }
        }
    }
]);
printjson(stationsParLigne.toArray());


print("\n5. Véhicules affectés à chaque ligne:");
const vehiculesParLigne = db.lignes.aggregate([
    {
        $lookup: {
            from: "vehicules",
            localField: "_id",
            foreignField: "lignes_affectees",
            as: "vehicules_affectes"
        }
    },
    {
        $project: {
            _id: 0,
            ligne: "$nom",
            type: "$type",
            vehicules: {
                $map: {
                    input: "$vehicules_affectes",
                    as: "vehicule",
                    in: {
                        id: "$$vehicule._id",
                        modele: "$$vehicule.modele",
                        capacite: "$$vehicule.capacite"
                    }
                }
            }
        }
    }
]);
printjson(vehiculesParLigne.toArray());


print("\n6. Nombre de passages par station:");
const passagesParStation = db.lignes.aggregate([
    { $unwind: "$horaires" },
    {
        $group: {
            _id: {
                station_id: "$horaires.station_id",
                station_nom: "$horaires.station_nom"
            },
            nombre_passages: { $sum: 1 },
            lignes: { $addToSet: "$nom" }
        }
    },
    {
        $project: {
            _id: 0,
            station_id: "$_id.station_id",
            station_nom: "$_id.station_nom",
            nombre_passages: 1,
            lignes_qui_desservent: "$lignes"
        }
    },
    { $sort: { nombre_passages: -1 } }
]);
printjson(passagesParStation.toArray());


print(". Analyse des performances - explain():");
const explainResult = db.lignes.find({
    "horaires.timestamp": {
        $gte: ISODate("2025-02-19T07:00:00Z"),
        $lte: ISODate("2025-02-19T09:00:00Z")
    }
}).explain("executionStats");

print("Temps d'exécution: " + explainResult.executionStats.executionTimeMillis + " ms");
print("Documents examinés: " + explainResult.executionStats.totalDocsExamined);
print("Index utilisé: " + (explineResult.executionStats.executionStages.inputStage?.indexName || "COLLSCAN"));

print("\n=== REQUÊTES TERMINÉES ===");