const db = require("./db");
const bcrypt = require("bcryptjs");
const { ObjectId } = require('mongodb');
const jwt = require("jsonwebtoken");


/////AUTHENTICATION/////
//POST /auth/register
//Request body: {username, password, email, phone, userType}
//Response: {id, username, password, email, phone, userType}
//Description: Adds a new user to the database
async function createUser(userData) {
    
    const dbconnection = await db.connectDatabase();
    
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(userData.password, salt);

    const result = await dbconnection.collection("Users").insertOne({ email: userData.email, password: hashedPassword,  userType: userData.userType, interested: [] });
    return result;
}



/////CONCERTS/////
async function addInterested(data)
{
    const dbconnection = await db.connectDatabase();
    //print out JSON data
    console.log(data);
    const result = await dbconnection.collection("Users").updateOne({_id: new ObjectId(data.userId)}, {$addToSet: {interested: new ObjectId(data.concertId)}});
    return result;
}


async function removeInterested(data)
{
    const dbconnection = await db.connectDatabase();
    console.log(data);
    const result = await dbconnection.collection("Users").updateOne({_id: new ObjectId(data.userId)}, {$pull: {interested: new ObjectId(data.concertId)}});
    return result;
}

module.exports = { createUser, addInterested, removeInterested };