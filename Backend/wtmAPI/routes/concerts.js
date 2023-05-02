const db = require("../db");
const express = require("express");

const concertsRouter = express.Router();

//GET all concerts from database in order of date
concertsRouter.get('/api/concerts', async (req, res) => {
    const dbconnection = await db.connectDatabase();
    const concerts = await dbconnection.collection("Concerts").find({}).toArray();
    //sort concerts by date
    concerts.sort((a, b) => {
        return new Date(a.date) - new Date(b.date);
    });
    res.send(concerts);
});


//GET Search Functionality by title 
concertsRouter.get('/api/concerts/search', async (req, res) => {
    const dbconnection = await db.connectDatabase();
    const concerts = await dbconnection.collection("Concerts").find({}).toArray();
   const search = req.query.search;
    const filteredConcerts = concerts.filter(concert => concert.title.toLowerCase().includes(search.toLowerCase()));
    res.send(filteredConcerts);
});

//GET concert by id
concertsRouter.get('/api/concerts/:id', async (req, res) => {
    const dbconnection = await db.connectDatabase();
    const concert = await dbconnection.collection("Concerts").findOne({ _id: req.params.id });
    res.send(concert);
});

//POST a new concert to the database
concertsRouter.post('/api/concerts', async (req, res) => {
    //call message queue 
    //check if user is an event organizer

});

concertsRouter.put('/api/concerts/interested', async (req, res) => {
    //need to verify user token //hanle this in the front end
    //call verify first then call interested if verified
    //call message queue
    //add user to concert's interested list
    try{
        await connectProducer("interested", {concertId, userId})
         const user = req.body;
         res.status(200).send(user);
    }catch(error)
    {
        console.log(error);
        res.status(500).json({message: error.message})
    }
});

//uninterested in a concert
concertsRouter.patch('/api/concerts/uninterested', async (req, res) => {
    //need to verify user token //hanle this in the front end
    //call verify first then call interested if verified
    //call message queue
    //remove user from concert's interested list
    try{
        await connectProducer("uninterested", {concertId, userId})
         const user = req.body;
         res.status(200).send(user);
    }catch(error)
    {
        console.log(error);
        res.status(500).json({message: error.message})
    }
});




module.exports = concertsRouter;