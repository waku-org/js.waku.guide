---
title: Send Messages Using Waku Light Push
date: 2021-12-09T14:00:00+01:00
weight: 6
---

# Send Messages Using Waku Light Push

Waku Light Push enables a client to receive a confirmation when sending a message.

The Waku Relay protocol sends messages to connected peers but does not provide any information on whether said peers have received messages.
This can be an issue when facing potential connectivity issues.
For example, when the connection drops easily, or it is connected to a small number of relay peers.

Waku Light Push allows a client to get a response from a remote peer when sending a message.
Note this only guarantees that the remote peer has received the message,
it cannot guarantee propagation to the network.

It also means weaker privacy properties as the remote peer knows the client is the originator of the message.
Whereas with Waku Relay, a remote peer would not know whether the client created or forwarded the message.

You can find Waku Light Push's specifications on [Vac RFC](https://rfc.vac.dev/spec/19/).

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

You can now send a message using Waku Light Push.
By default, it sends the messages to a single randomly selected light push peer.
The peer is selected among the dApp's connected peers.

If the dApp is not connected to any light push peer, an error is thrown.

```js
import { WakuMessage } from "js-waku";

const wakuMessage = await WakuMessage.fromUtf8String(
  "Here is a message",
  `/light-push-guide/1/guide/proto`
);

const ack = await waku.lightPush.push(wakuMessage);
if (!ack?.isSuccess) {
  // Message was not sent
}
```
