const MongoClient = require("mongodb").MongoClient;

//const uri = "mongodb://localhost:5010/"; //local testing
//const uri = "mongodb://172.18.0.1:5010/"; //docker testing
const uri = "mongodb://wtmdb:27017/"; //docker testing

const dbName = "WhatsTheMove";

let dbconnection;

async function connectDatabase() {
    if (dbconnection) {
        return dbconnection;
    }
    const client = new MongoClient(uri);
    try {
        await client.connect();
        dbconnection = client.db(dbName);
        console.log("Connected to database");
        return dbconnection;
    } catch (err) {
        console.log("Error connecting to database", err);
        throw err; 
    }
}

module.exports = {connectDatabase};