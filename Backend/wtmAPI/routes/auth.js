const db = require("../db");
const express = require("express");
const { connectProducer } = require("../streams/kafka");
const { resetWatchers } = require("nodemon/lib/monitor/watch");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { ObjectId } = require('mongodb');

const authRouter = express.Router();

/**
 * 
 * User Schema
 * user = {
 * name: String,
 * email: String,
 * password: String,
 * type: String,
 * concerts: [concerts]
 * }
 */

//GET a user by id
authRouter.get('/api/users/:id', async (req, res) => {
    const dbconnection = await db.connectDatabase();
    const user = await dbconnection.collection("Users").findOne({ _id: req.params.id });
    res.send(user);
});

//TEST GET , return a message
authRouter.get('/api/users', async (req, res) => {
    res.send("Hello World");
});

authRouter.post('/api/register', async (req, res) => {
    "Name , email, password, and user type are required"
    console.log(req.body);
    const { name, email, password, userType } = req.body;
    //check if email already exists
    const dbconnection = await db.connectDatabase();
    const user = await dbconnection.collection("Users").findOne({ email: req.body.email });
    if (user) {
        return res.status(400).send("Email already exists");
    }
    //send to message queue
    try{
        await connectProducer("register", req.body)
         const user = req.body;
         res.status(201).send(user);
    }catch(error)
    {
        console.log(error);
        res.status(500).json({message: error.message})
    }

});

authRouter.post('/api/login', async (req, res) => {
    "Email and password are required"
    const dbconnection = await db.connectDatabase();
    const { email, password } = req.body;
    //send to message queue
    const user = await dbconnection.collection("Users").findOne({ email: req.body.email });
    if(!user)
    {
        //user does not exist
        return res.status(400).send("Email does not exist");
    }
    const validPassword = await bcrypt.compare(req.body.password, user.password);
    if(!validPassword)
    {
        return res.status(400).send("Invalid password");
    }
    try{
         //create and assign a token
        const token = "verified";
         res.status(200).send(token);
    }catch(error)
    {
        console.log(error);
        res.status(500).json({message: error.message})
    }
});

//token verification
authRouter.post('/api/verify', async (req, res) => {
    "Token is required"
    const { token } = req.body;
    //send to message queue
    try{
       if (req.body.token === "verified") {
        res.status(200).send(
            "Token verified"
        );
       }
         else {
        res.status(400).send("Invalid token");
         }
         
    }catch(error)
    {
        console.log(error);
        res.status(500).json({message: error.message})
    }
});




module.exports = authRouter;

