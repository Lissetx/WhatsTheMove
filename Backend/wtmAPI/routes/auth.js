const db = require("../db");
const express = require("express");

const authRouter = express.Router();

authRouter.post('/api/register', (req, res) => {
    "Name , email, password, and user type are required"
    const { name, email, password, userType } = req.body;
    //send to message queue
    
});

