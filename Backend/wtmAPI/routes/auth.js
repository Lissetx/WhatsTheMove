const db = require("../db");
const express = require("express");

const authRouter = express.Router();

//GET a user by id
authRouter.get('/api/users/:id', async (req, res) => {
    const dbconnection = await db.connectDatabase();
    const user = await dbconnection.collection("Users").findOne({ _id: req.params.id });
    res.send(user);
});

authRouter.post('/api/register', (req, res) => {
    "Name , email, password, and user type are required"
    const { name, email, password, userType } = req.body;
    //send to message queue

});

authRouter.post('/api/login', (req, res) => {
    "Email and password are required"
    const { email, password } = req.body;
    //send to message queue
});

//token verification
authRouter.post('/api/verify', (req, res) => {
    "Token is required"
    const { token } = req.body;
    //send to message queue
});




module.exports = authRouter;

