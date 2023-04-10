const express = require("express");
var app = express();

const { connectDatabase } = require("./db");
port = 5050;


connectDatabase();

app.listen(port, async () => {
    console.log("Listening on port " + port);
});





