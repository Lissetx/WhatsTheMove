const express = require("express");
var app = express();

const authRouter = require("./routes/auth");
const concertsRouter = require("./routes/concerts");
//import 'package:flutter/material.dart';

const { connectDatabase } = require("./db");
port = 5050;

app.use(express.json());

app.use(authRouter);
app.use(concertsRouter);

connectDatabase();

app.listen(port, async () => {
    console.log("Listening on port " + port);
});





