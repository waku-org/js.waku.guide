---
title: Build a Chat App
date: 2023-03-01T14:00:00+10:00
weight: 1
---

# Build a Chat App

In this guide you will learn how to receive and send messages using Waku by building an app from scratch.
If you want to learn how to add Waku to an existing app, check the [/quick_start] guide.

This guide is kept succinct on purpose, check out the other [guides](/docs/guides) to learn more.

## 1. Setup Project

Setup a new npm package:

```shell
mkdir waku-app
cd waku-app
npm init
```

Hit `<enter>` for all questions.

## 2. Setup Webserver

Use the `serve` package as a webserver

```shell
npm i -D serve
```

Add a `start` script to the `package.json` file:

```json
{
  "scripts": {
    "start": "serve ."
  }
}
```

Finally, create empty files for your project:

```shell
touch index.html index.js
```

## 3. HTML Button and Text Box

In `index.html`, add a button, text box and `div` for messages to have a basic chat app.
Also, import the `index.js` file.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>JS-Waku Quick Start App</title>
</head>
<body>
<label for="textInput">Message text</label>
<input id="textInput" placeholder="Type your message here" type="text"/>
<button disabled id="send" type="button">
    Send message using Light Push
</button>
<br/>
<div id="messages"></div>
<script src="./index.js" type="module"></script>
</body>
</html>
```

## 4. Access HTML Element

{{< hint info >}}
From now, all changes needs to be done in the `index.js` file.
{{< /hint >}}

Initialize variables to easily modify the HTML content:

```js
const sendButton = document.getElementById("send")
const messagesDiv = document.getElementById("messages")
const textInput = document.getElementById("textInput")
```

## 5. Start a Waku Node

Create and start a Waku Node:

```js
import {createLightNode} from "https://unpkg.com/@waku/create@0.0.6/bundle/index.js"

const waku = await createLightNode({defaultBootstrap: true})
await waku.start()
```

{{< hint info >}}
The `defaultBootstrap` option enables your Waku node to connect to set a pre-defined nodes.
This can be modified in the future.
{{< /hint >}}

## 6. Wait to be connected

The Waku node needs to first connect to bootstrap nodes to establish a connection.
To wait for this, use the `waitForRemotePeer` function:

```js
import * as waku from "https://unpkg.com/@waku/core@0.0.10/bundle/index.js"

await waku.waitForRemotePeer(wakuNode)
```

## 7. Define a Content Topic

The `contentTopic` is a metadata `string` that allows categorization of messages on the Waku network.
Depending on your use case, you can either create one (or several) new `contentTopic`(s).
See [How to Choose a Content Topic](/docs/guides/01_choose_content_topic/) for more details.

For now, let's use `/js-waku-examples/1/chat/utf8` for this guide.
Note that we will be encoding our payload using `utf-8`. Note that Protobuf is recommended for production usage.

```js
const contentTopic = `/js-waku-examples/1/chat/utf8`
```

## 8. Create a Decoder

Waku offers several encryption protocols,
a decoder enables you to specify what content topic to use and how to decrypt messages.

Create a decoder for plain text decoding (no encryption), for the chose content topic:

```js
const decoder = waku.createDecoder(contentTopic)
```

## 9. Render Incoming Messages

Let's store incoming messages in an array and create a function to render them in the `messages` div:

```js
const updateMessages = (msgs, div) => {
    div.innerHTML = "<ul>"
    msgs.forEach((msg) => (div.innerHTML += "<li>" + msg + "</li>"))
    div.innerHTML += "</ul>"
};

const messages = []
```

## 10. Listen for Incoming Messages

Messages sent over the network are `Waku Message`s.
You can check the wire format here: https://rfc.vac.dev/spec/14/#wire-format

The interface for a plain text decoder is [`DecodedMessage`](https://js.waku.org/classes/_waku_core.DecodedMessage.html).

For now, we will just use the `payload` field.
It is a byte array field you can use to encode any data you want.
We will use it to store messages as `utf-8`.

Listen to messages using the decoder and add them to the `messages` div upon reception:

```ts
wakuNode.filter.subscribe([decoder], (message) => {
    const str = utils.bytesToUtf8(message.payload)
    messages.push(str)
    updateMessages(messages, messagesDiv);
})
```

## 11. Send Messages

Finally, create a plain text encoder and setup the `send` button to send messages.
The users will be able to enter the message using the `textInput` div.

Once done, we can enable the `send` button.

```ts
const encoder = waku.createEncoder(contentTopic)

sendButton.onclick = async () => {
    const text = textInput.value;

    await wakuNode.lightPush.push(encoder, {
        payload: utils.utf8ToBytes(text),
    });
    textInput.value = null;
};
sendButton.disabled = false
```

### 12. Run the App

You can now start a local webserver to run the app:

```shell
npm start
```

Click on the link the console (http://localhost:3000/) and send a message!
You can open your app in several tabs to see messages being sent around.

## Conclusion

Congratulations for building your first Waku app.
See below the complete files:

`index.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>JS-Waku Quick Start App</title>
</head>
<body>
<label for="textInput">Message text</label>
<input id="textInput" placeholder="Type your message here" type="text"/>
<button disabled id="send" type="button">
    Send message using Light Push
</button>
<br/>
<div id="messages"></div>
<script src="./index.js" type="module"></script>
</body>
</html>
```

`index.js`
```js
import {createLightNode} from "https://unpkg.com/@waku/create@0.0.6/bundle/index.js"
import * as waku from "https://unpkg.com/@waku/core@0.0.10/bundle/index.js"
import * as utils from "https://unpkg.com/@waku/byte-utils@0.0.2/bundle/index.js"

const sendButton = document.getElementById("send")
const messagesDiv = document.getElementById("messages")
const textInput = document.getElementById("textInput")

const wakuNode = await createLightNode({defaultBootstrap: true})
await wakuNode.start()

await waku.waitForRemotePeer(wakuNode)

const contentTopic = `/js-waku-examples/1/chat/utf8`
const decoder = waku.createDecoder(contentTopic)

const updateMessages = (msgs, div) => {
    div.innerHTML = "<ul>"
    msgs.forEach((msg) => (div.innerHTML += "<li>" + msg + "</li>"))
    div.innerHTML += "</ul>"
};

const messages = []

wakuNode.filter.subscribe([decoder], (message) => {
    const str = utils.bytesToUtf8(message.payload)
    messages.push(str)
    updateMessages(messages, messagesDiv);
})

const encoder = waku.createEncoder(contentTopic)

sendButton.onclick = async () => {
    const text = textInput.value;

    await wakuNode.lightPush.push(encoder, {
        payload: utils.utf8ToBytes(text),
    });
    textInput.value = null;
};
sendButton.disabled = false
```
