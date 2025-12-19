
// import.js : importer CSV, JSON et XML dans MongoDB


const fs = require('fs');
const parse = require('csv-parse/lib/sync');
const xml2js = require('xml2js');
const { MongoClient, ObjectId } = require('mongodb');

const url = 'mongodb://localhost:27017';
const dbName = 'transports_urbains';

async function main() {
    const client = new MongoClient(url);
    await client.connect();
    const db = client.db(dbName);

    console.log("Connecté à MongoDB :", dbName);

    
    // Import stations CSV
    
    const stationsCSV = fs.readFileSync('data/stations.csv', 'utf8');
    const stations = parse(stationsCSV, {
        columns: true,
        skip_empty_lines: true,
        delimiter: ';'
    }).map(s => ({
        _id: parseInt(s.id),
        nom: s.nom,
        commune: s.commune,
        location: { type: "Point", coordinates: [parseFloat(s.longitude), parseFloat(s.latitude)] },
        lignes_qui_desservent: []
    }));

    await db.collection('stations').deleteMany({});
    await db.collection('stations').insertMany(stations);
    console.log("Stations importées :", stations.length);

    
    // Import lignes JSON
    
    const lignesJSON = JSON.parse(fs.readFileSync('data/lignes.json', 'utf8'));
    await db.collection('lignes').deleteMany({});
    await db.collection('lignes').insertMany(lignesJSON);
    console.log("Lignes importées :", lignesJSON.length);


    const vehiculesJSON = JSON.parse(fs.readFileSync('data/vehicules.json', 'utf8'));
    await db.collection('vehicules').deleteMany({});
    await db.collection('vehicules').insertMany(vehiculesJSON);
    console.log("Véhicules importés :", vehiculesJSON.length);

    
    // Import horaires XML
    
    const horairesXML = fs.readFileSync('data/horaires.xml', 'utf8');
    const parser = new xml2js.Parser({ explicitArray: false });
    const result = await parser.parseStringPromise(horairesXML);
    const horaires = result.horaires.horaire.map(h => ({
        ligne_id: parseInt(h.ligne),
        station_id: parseInt(h.station),
        timestamp: new Date(h.timestamp)
    }));


    for (const h of horaires) {
        await db.collection('lignes').updateOne(
            { _id: h.ligne_id },
            { $push: { horaires: h } }
        );
    }
    console.log("Horaires importés :", horaires.length);

    await db.collection('stations').createIndex({ location: "2dsphere" });
    await db.collection('lignes').createIndex({ "horaires.timestamp": 1 });
    await db.collection('vehicules').createIndex({ id: 1 });

    console.log("Import terminé avec succès !");
    await client.close();
}

main().catch(console.error);
