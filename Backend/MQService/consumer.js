const {Kafka} = require('kafkajs')
const brokerAddress = 'broker:29092'
const WTMTopic = 'WTMTopic'

const kafka = new Kafka({
    brokers : [brokerAddress],
    clientId: 'wtmAPI-consumer'
})
const consumer = kafka.consumer({groupId: 'wtmAPI-group'})

async function connectConsumer(handler) {
    await consumer.connect()
    await consumer.subscribe({topic: WTMTopic})
    await consumer.run({
        eachMessage: async ({topic, partition, message, heartbeat, pause }) => handler(message)
    })
}

module.exports = connectConsumer