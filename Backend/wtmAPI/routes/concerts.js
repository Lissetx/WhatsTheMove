const db = require("../db");
const express = require("express");
const { ObjectId } = require('mongodb');
const { connectProducer } = require("../streams/kafka");

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
    //const concerts = await dbconnection.collection("Concerts").find({}).toArray();
    //only find by title 
    const concerts = await dbconnection.collection("Concerts").find({}, {title: 1}).toArray();
   const search = req.query.search;
    const filteredConcerts = concerts.filter(concert => concert.title.toLowerCase().includes(search.toLowerCase()));
    res.send(filteredConcerts);
});

//GET concert by id
concertsRouter.get('/api/concerts/:id', async (req, res) => {
    const dbconnection = await db.connectDatabase();
    const concert = await dbconnection.collection("Concerts").findOne({ _id: new ObjectId(req.params.id) });
    res.send(concert);
});

//GET all concerts by a user is interested in
//user has a array of concerts they are interested in called interested

concertsRouter.get('/api/concerts/interested/:id', async (req, res) => {
    const dbconnection = await db.connectDatabase();
    const concertIds = await dbconnection.collection("Users").findOne({ _id: new ObjectId(req.params.id) }, { interested: 1 });
    const concerts = await dbconnection.collection("Concerts").find({ _id: { $in: concertIds.interested } }).toArray();
    res.send(concerts);
});




concertsRouter.put('/api/concerts/interested', async (req, res) => {
    //need to verify user token //handle this in the front end
    //call verify first then call interested if verified
    //call message queue
    //add user to concert's interested list
    
    try{
        await connectProducer("interested", req.body)
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
    //need to verify user token //handle this in the front end
    //call verify first then call interested if verified
    //call message queue
    //remove user from concert's interested list
    
    try{
        await connectProducer("uninterested", req.body)
         const user = req.body;
         res.status(200).send(user);
    }catch(error)
    {
        console.log(error);
        res.status(500).json({message: error.message})
    }
});




module.exports = concertsRouter;