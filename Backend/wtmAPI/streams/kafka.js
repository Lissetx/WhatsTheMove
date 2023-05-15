const {Kafka} = require('kafkajs')
const brokerAddress = process.env.BROKER_SERVER_ADDRESS
const WTMTopic = process.env.WTM_TOPIC

const kafka = new Kafka({
    brokers : [brokerAddress],
    clientId: 'wtmAPI-producer'
})

const producer = kafka.producer()

async function connectProducer(apiEvent, apiData) {
    await producer.connect()
    console.log("Connected to producer")
    producer.send({
        topic: WTMTopic,
        messages: [
            {key: apiEvent,
            value: JSON.stringify(apiData)}
            
        ]
    })
}

module.exports = {connectProducer}
