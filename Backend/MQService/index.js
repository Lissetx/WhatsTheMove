const connectConsumer = require('./consumer')
const {createUser, addInterested, removeInterested} = require('./buisnesslogic.js')

async function main() {
    console.log("Starting consumer")
    connectConsumer(handleEvent);
}

function handleEvent(message) {
    var key = message.key.toString();
    var data = JSON.parse(message.value.toString());
    switch(key)
    {
        case "register":
            createUser(data);
            break;
        case "interested":
            addInterested(data);
            break;
        case "uninterested":
            removeInterested(data);
            break;
        
    }
}

main().catch(console.error);