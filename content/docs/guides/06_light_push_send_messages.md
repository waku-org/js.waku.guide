---
title: Send Messages Using Waku Light Push and Receive Messages Using Waku Filter
date: 2023-02-13T14:00:00+01:00
weight: 6
---

# Send Messages using Waku Light Push

[Waku Light Push](https://github.com/waku-org/waku.guide/blob/staging/docs/Concepts/protocols-explained.md#waku-light-push) enables a client to receive a confirmation when sending a message.

The Waku Relay protocol sends messages to connected peers but does not provide any information on whether said peers have received messages.
This can be an issue when facing potential connectivity issues.
For example, when the connection drops easily, or it is connected to a small number of relay peers.

Waku Light Push allows a client to get a response from a remote peer when sending a message.
Note this only guarantees that the remote peer has received the message,
it cannot guarantee propagation to the network.

It also means weaker privacy properties as the remote peer knows the client is the originator of the message.
Whereas with Waku Relay, a remote peer would not know whether the client created or forwarded the message.

You can find Waku Light Push's specifications on [Vac RFC](https://rfc.vac.dev/spec/19/).

# Receive Messages using Waku Filter

[Waku Filter](https://github.com/waku-org/waku.guide/blob/staging/docs/Concepts/protocols-explained.md#waku-filter) enables a client to subscribe to specific messages received by a peer without the need for a direct connection, resulting in more efficient use of bandwidth while potentially sacrificing privacy.

# Content Topic

Before starting, you need to choose a _Content Topic_ for your dApp.
Check out the [how to choose a content topic guide](/docs/guides/01_choose_content_topic/) to learn more about content topics.

For this guide, we are using a single content topic: `/light-push-guide/1/guide/proto`.

# Installation

You can install [js-waku](https://npmjs.com/package/js-waku) using your favorite package manager:

```shell
npm install js-waku
```

# Create Waku Instance

In order to interact with the Waku network, you first need a Waku instance:

```js
import { Waku } from "js-waku";

const wakuNode = await Waku.create({ bootstrap: { default: true } });
```

Passing the `bootstrap` option will connect your node to predefined Waku nodes.
If you want to bootstrap to your own nodes, you can pass an array of multiaddresses instead:

```js
import { Waku } from "js-waku";

const waku = await Waku.create({
  bootstrap: {
    peers: [
      "/dns4/node-01.ac-cn-hongkong-c.wakuv2.test.statusim.net/tcp/443/wss/p2p/16Uiu2HAkvWiyFsgRhuJEb9JfjYxEkoHLgnUQmr1N5mKWnYjxYRVm",
      "/dns4/node-01.do-ams3.wakuv2.test.statusim.net/tcp/443/wss/p2p/16Uiu2HAmPLe7Mzm8TsYUubgCAW1aJoeFScxrLj8ppHFivPo97bUZ",
    ],
  },
});
```

# Wait to be connected

When using the `bootstrap` option, it may take some time to connect to other peers.
To ensure that you have a light push peer available to send messages to,
use the following function:

```js
await waku.waitForRemotePeer();
```

The returned `Promise` will resolve once you are connected to a Waku peer.

# Send messages

To send a message, you need to use the `@waku/create` library to create a Waku Light Node and the `@waku/core` library to encode the message. 

## Import the required libraries

```ts
import * as utils from "@waku/byte-utils";
import * as wakuCreate from "@waku/create";
import { createEncoder, waitForRemotePeer } from "@waku/core";
```

## Define the required constants

```ts
const MULTI_ADDR = "your Waku multi-address";
const CONTENT_TOPIC = "your content topic";
const PROTOCOLS = ["filter", "lightpush"];
```

## Create a Waku Light Node

```ts
const node = await wakuCreate.createLightNode({ defaultBootstrap: true });
await node.start();
await waitForRemotePeer(node, protocols);
```

## Create an encoder for the message

```ts
const Encoder = createEncoder(CONTENT_TOPIC);
```

## Define the structure of the message

```ts
const ChatMessage = new protobuf.Type("ChatMessage")
  .add(new protobuf.Field("timestamp", 1, "uint64"))
  .add(new protobuf.Field("nick", 2, "string"))
  .add(new protobuf.Field("text", 3, "bytes"));
```

## Create a message object and encode it 

```ts
const message = ChatMessage.create({
  nick: "your nick",
  timestamp: Date.now(),
  text: utils.utf8ToBytes("your message"),
});
const protoMessage = ChatMessage.encode(message).finish();
```

## Push the encoded message to the network

```ts
await node.lightPush.push(Encoder, {
  payload: protoMessage,
});
```

# Receive messages

To receive messages, you need to subscribe to the Waku Filter, decode the incoming payload using a decoder specific to the content topic of the message, and then pass the decoded message to a callback function for processing.

## Import the required libraries

```ts
import * as utils from "@waku/byte-utils";
import * as wakuCreate from "@waku/create";
import { createDecoder, waitForRemotePeer } from "@waku/core";
```

## Define the Waku Node connection parameters

```ts
const MULTI_ADDR = "/dns4/node-01.ac-cn-hongkong-c.wakuv2.test.statusim.net/tcp/443/wss/p2p/16Uiu2HAkvWiyFsgRhuJEb9JfjYxEkoHLgnUQmr1N5mKWnYjxYRVm";
const CONTENT_TOPIC = "/toy-chat/2/huilong/proto";
const PROTOCOLS = ["filter"];
```

## Create the Waku Node

```ts
const node = await wakuCreate.createLightNode({ defaultBootstrap: true });
```

## Start the Waku Node

```ts
await node.start();
```

## Wait for remote peers to be connected

```ts
await waitForRemotePeer(node, PROTOCOLS);
```

## Define the protobuf type for the messages

```ts
const ChatMessage = new protobuf.Type("ChatMessage")
  .add(new protobuf.Field("timestamp", 1, "uint64"))
  .add(new protobuf.Field("nick", 2, "string"))
  .add(new protobuf.Field("text", 3, "bytes"));
```

## Create a decoder for the content topic

```ts
const Decoder = createDecoder(CONTENT_TOPIC);
```

## Subscribe to the messages

```ts
const unsubscribeFromMessages = await node.filter.subscribe([Decoder], (wakuMessage) => {
  const messageObj = ChatMessage.decode(wakuMessage.payload);
  onMessageReceived({
    ...messageObj,
    text: utils.bytesToUtf8(messageObj.text),
  });
});
```

## Process the received message by decoding it 

```ts
const onMessageReceived = (messageObj) => {
  // process the received message
};
```

## Unsubscribe from the messages, when you no longer need to receive them

```ts
await unsubscribeFromMessages();
```

# Create a user interface for your chat application

To create a user interface for a web application based on the code above, you need to create an HTML file with the basic structure, including user elements. The HTML file should include links to a CSS stylesheet and the JavaScript file needed to run the application. The JavaScript code will need to include the `initUI()` function to create the UI adapter, which sets up event listeners and renderers for various UI elements. The main `runApp()` function will then use the returned UI adapter to update the user interface and respond to user actions.

## Create a HTML structure

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>JS-Waku light chat</title>
    <link rel="stylesheet" href="./style.css" />
    <link rel="apple-touch-icon" href="./favicon.png" />
    <link rel="manifest" href="./manifest.json" />
    <link rel="icon" href="./favicon.ico" />
  </head>

  <body>
    <!-- Your user interface elements will go here -->
  </body>
</html>
```

## Include the necessary libraries

Add the following code in the `<head>` section of the HTML file:

```html
<script src="//cdn.jsdelivr.net/npm/protobufjs@7.X.X/dist/protobuf.min.js"></script>
<script type="module" src="./index.js"></script>
```

## Add a style sheet

Create a new file named style.css in the same directory as the HTML file and add the styles required for the user interface.


## Add the UI adapter to the code

The `initUI` function will initialize the user interface and return an object with methods that can be used to interact with it. The `initUI` function first finds these elements (sunch as buttons, blocks, inputs, and text areas) using the `document.getElementById` method. The function then returns an object that has methods (such as `onExit`, `onSendMessage`, `setStatus`, `setLocalPeer`, `setRemotePeer`, `setRemoteMultiAddr`) for interacting with the user interface.

```ts
// UI adapter
function initUI() {
  const exitButton = document.getElementById("exit");
  const sendButton = document.getElementById("send");

  const statusBlock = document.getElementById("status");
  const localPeerBlock = document.getElementById("localPeerId");
  const remotePeerId = document.getElementById("remotePeerId");
  const remoteMultiAddr = document.getElementById("remoteMultiAddr");
  const contentTopicBlock = document.getElementById("contentTopic");

  const messagesBlock = document.getElementById("messages");

  const nickText = document.getElementById("nickText");
  const messageText = document.getElementById("messageText");

  return {
    // UI events
    onExit: (cb) => {
      exitButton.addEventListener("click", cb);
    },
    onSendMessage: (cb) => {
      sendButton.addEventListener("click", async () => {
        await cb({
          nick: nickText.value,
          text: messageText.value,
        });
        messageText.value = "";
      });
    },
    // UI renderers
    setStatus: (value, className) => {
      statusBlock.innerHTML = `<span class=${className || ""}>${value}</span>`;
    },
    setLocalPeer: (id) => {
      localPeerBlock.innerText = id.toString();
    },
    setRemotePeer: (ids) => {
      remotePeerId.innerText = ids.join("\n");
    },
    setRemoteMultiAddr: (multiAddr) => {
      remoteMultiAddr.innerText = multiAddr.toString();
    },
    setContentTopic: (topic) => {
      contentTopicBlock.innerText = topic.toString();
    },
    renderMessage: (messageObj) => {
      const { nick, text, timestamp } = messageObj;
      const date = new Date(timestamp);

      // WARNING: XSS vulnerable
      messagesBlock.innerHTML += `
                <div class="message">
                    <p>${nick} <span>(${date.toDateString()})</span>:</p>
                    <p>${text}</p>
                <div>
            `;
    },
    resetMessages: () => {
      messagesBlock.innerHTML = "";
    },
  };
}
```


