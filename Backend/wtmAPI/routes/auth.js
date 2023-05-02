const db = require("../db");
const express = require("express");
const { connectProducer } = require("../streams/kafka");
const { resetWatchers } = require("nodemon/lib/monitor/watch");

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

authRouter.post('/api/register', async (req, res) => {
    "Name , email, password, and user type are required"
    const { name, email, password, userType } = req.body;
    //send to message queue
    try{
        await connectProducer("register", {name, email, password, userType})
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
    const { email, password } = req.body;
    //send to message queue
    try{
        await connectProducer("login", {email, password})
         const user = req.body;
         res.status(200).send(user);
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
        await connectProducer("verify", {token})
         const user = req.body;
         res.status(200).send(user);
    }catch(error)
    {
        console.log(error);
        res.status(500).json({message: error.message})
    }
});




module.exports = authRouter;

