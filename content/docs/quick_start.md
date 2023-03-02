---
title: Quick Start
date: 2021-12-09T14:00:00+01:00
weight: 20
---

# Quick Start

In this guide you will learn how to add Waku to an **existing** JavaScript project.

If you want to build a Waku app from scratch, check out the [Build a Chat App](/docs/guides/chat_app/) guide.

This guide is kept succinct on purpose, check out other [guides](/docs/guides/) to learn more.

## 1. Install Waku Libraries

```shell
npm i @waku/core @waku/create
```

## 2. Start a Waku Node

Create and start a Waku Node:

```js
import {createLightNode} from "@waku/create"

const waku = await createLightNode({defaultBootstrap: true})
await waku.start()
```

{{< hint info >}}
The `defaultBootstrap` option enables your Waku node to connect to set a pre-defined nodes.
This can be modified in the future.
{{< /hint >}}

## 3. Wait to be connected

The Waku node needs to first connect to bootstrap nodes to establish a connection.
To wait for this, use the `waitForRemotePeer` function:

```js
import * as waku from "@waku/core"

await waku.waitForRemotePeer(wakuNode)
```

## 4. Define a Content Topic

The `contentTopic` is a metadata `string` that allows categorization of messages on the Waku network.
Depending on your use case, you can either create one (or several) new `contentTopic`(s).
See [How to Choose a Content Topic](/docs/guides/01_choose_content_topic/) for more details.

For now, let's use `/quick-start/1/message/utf8` for this guide.
Note that we will be encoding our payload using `utf-8`.
Note that Protobuf is recommended for production usage.

```js
const contentTopic = `/quick-start/1/message/utf8`
```

## 5. Create a Decoder

Waku offers several encryption protocols,
a decoder enables you to specify what content topic to use and how to decrypt messages.

Create a decoder for plain text decoding (no encryption), for the chose content topic:

```js
const decoder = waku.createDecoder(contentTopic)
```

## 6. Listen for Incoming Messages

Messages sent over the network are `Waku Message`s.
You can check the wire format here: https://rfc.vac.dev/spec/14/#wire-format

The interface for a plain text decoder is [`DecodedMessage`](https://js.waku.org/classes/_waku_core.DecodedMessage.html).

For now, we will just use the `payload` field.
It is a byte array field you can use to encode any data you want.
We will use it to store messages as `utf-8`.

Listen to messages using the decoder:

```ts
wakuNode.filter.subscribe([decoder], (message) => {
    const str = utils.bytesToUtf8(message.payload)
    // str is a string, render it in your app anyway you wish
})
```

## 7. Send Messages

Finally, create a `sendMessage` function that will send messages over Waku:

```ts
const encoder = waku.createEncoder(contentTopic)

const sendMessage = async (textMsg) => {
    await wakuNode.lightPush.push(encoder, {
        payload: utils.utf8ToBytes(textMsg),
    });
};
```

You can use `sendMessage` in your app to send messages.

## Conclusion

You have added decentralized communication features to your app!

Check out other [guides](/docs/guides/) to learn more or join us on [Discord](https://discord.gg/Nrac59MfSX).
