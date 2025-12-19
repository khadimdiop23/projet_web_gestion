

const { MongoClient } = require('mongodb');

const url = 'mongodb://localhost:27017';
const dbName = 'transports_urbains';

async function main() {
    const client = new MongoClient(url);
    await client.connect();
    const db = client.db(dbName);

    console.log("Connecté à MongoDB :", dbName);

    // Ex : 5 prochains passages à "Gare Centre"
    const lignes = await db.collection('lignes').aggregate([
        { $unwind: "$horaires" },
        { $lookup: {
            from: "stations",
            localField: "horaires.station_id",
            foreignField: "_id",
            as: "station_info"
        }},
        { $unwind: "$station_info" },
        { $match: { "station_info.nom": "Gare Centre", "horaires.timestamp": { $gt: new Date() } } },
        { $sort: { "horaires.timestamp": 1 } },
        { $limit: 5 },
        { $project: {
            _id: 0,
            ligne: "$nom",
            type: "$type",
            station: "$station_info.nom",
            timestamp: "$horaires.timestamp"
        }}
    ]).toArray();

    console.log("Prochains passages à Gare Centre :", lignes);

    await client.close();
}

main().catch(console.error);
