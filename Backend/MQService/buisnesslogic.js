const db = require("./db");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");


/////AUTHENTICATION/////
//POST /auth/register
//Request body: {username, password, email, phone, userType}
//Response: {id, username, password, email, phone, userType}
//Description: Adds a new user to the database
async function createUser(username, password, email, phone, userType) {
    const dbconnection = await db.connectDatabase();
    const user = await dbconnection.collection("Users").findOne({ username: username });
    //HASH THE PASSWORD 

    if (user) {
        throw new Error("Username already exists");
    }
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const result = await dbconnection.collection("Users").insertOne({ username: username, password: hashedPassword, email: email, phone: phone, userType: userType });
    return result.ops[0];
}

async function loginUser(email, password)
{
    const dbconnection = await db.connectDatabase();
    const user = await dbconnection.collection("Users").findOne({ email: email });
    if(!user)
    {
        throw new Error("Email does not exist");
    }
    const validPassword = await bcrypt.compare(password, user.password);
    if(!validPassword)
    {
        throw new Error("Invalid password");
    }
    //create and assign a token
    const token = jwt.sign({_id: user._id}, process.env.TOKEN_SECRET);
    return token;
}

async function verifyUser(token)
{
    const decoded = jwt.verify(token, process.env.TOKEN_SECRET);
    return decoded;
}

/////CONCERTS/////
async function addInterested(concertId, userId)
{
    const dbconnection = await db.connectDatabase();
    const user = await dbconnection.collection("Users").findOne({ _id: userId });
    if(!user)
    {
        throw new Error("User does not exist");
    }
    const result = await dbconnection.collection("Users").updateOne({_id: userId}, {$addToSet: {interested: concertId}});
    return result;
}


async function removeInterested(concertId, userId)
{
    const dbconnection = await db.connectDatabase();
    const user = await dbconnection.collection("Users").findOne({ _id: userId });
    if(!user)
    {
        throw new Error("User does not exist");
    }
    const result = await dbconnection.collection("Users").updateOne({_id: userId}, {$pull: {interested: concertId}});
    return result;
}

module.exports = { createUser, loginUser, verifyUser, addInterested, removeInterested };