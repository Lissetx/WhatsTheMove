const express = require("express");
var app = express();

const authRouter = require("./routes/auth");
//import 'package:flutter/material.dart';

const { connectDatabase } = require("./db");
port = 5050;

app.use(authRouter);
app.use(ConcertsRouter);

connectDatabase();

app.listen(port, async () => {
    console.log("Listening on port " + port);
});





