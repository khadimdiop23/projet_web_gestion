

const { ObjectId } = require('mongodb');

// Station
class Station {
    constructor(id, nom, commune, longitude, latitude, lignes_qui_desservent = []) {
        this._id = id;
        this.nom = nom;
        this.commune = commune;
        this.location = { type: "Point", coordinates: [longitude, latitude] };
        this.lignes_qui_desservent = lignes_qui_desservent;
    }
}

// Ligne
class Ligne {
    constructor(id, nom, type, horaires = [], stations_ids = []) {
        this._id = id;
        this.nom = nom;
        this.type = type;
        this.horaires = horaires;
        this.stations_ids = stations_ids;
    }
}

// Véhicule
class Vehicule {
    constructor(id, modele, capacite, lignes_affectees = []) {
        this._id = id;
        this.modele = modele;
        this.capacite = capacite;
        this.lignes_affectees = lignes_affectees;
    }
}

module.exports = { Station, Ligne, Vehicule };
