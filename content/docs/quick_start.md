---
title: Quick Start
date: 2021-12-09T14:00:00+01:00
weight: 20
---
# Quick Start

In this section you will learn how to receive and send messages using Waku Relay.

A more in depth guide for Waku Relay can be found [here](/docs/guides/02_relay_receive_send_messages/).

## Install

Install the `js-waku` package:

```shell
npm install js-waku
# or with yarn
yarn add js-waku
```

### Start a waku node

```ts
import { Waku } from 'js-waku';

const waku = await Waku.create({ bootstrap: true });
```

### Listen for messages

The `contentTopic` is a metadata `string` that allows categorization of messages on the waku network.
Depending on your use case, you can either create one (or several) new `contentTopic`(s)
or look at the [RFCs](https://rfc.vac.dev/) and use an existing `contentTopic`.
See [How to Choose a Content Topic](/docs/guides/01_choose_content_topic/) for more details.

For example, if you were to use a new `contentTopic` such as `/my-cool-app/1/my-use-case/proto`,
here is how to listen to new messages received via [Waku v2 Relay](https://rfc.vac.dev/spec/11/):

```ts
waku.relay.addObserver((msg) => {
  console.log("Message received:", msg.payloadAsUtf8)
}, ["/my-cool-app/1/my-use-case/proto"]);
```

### Send messages

Messages are wrapped in a `WakuMessage` envelop.

```ts
import { WakuMessage } from 'js-waku';

const msg = await WakuMessage.fromUtf8String("Here is a message!", "/my-cool-app/1/my-use-case/proto")
await waku.relay.send(msg);
```

### Building an app

Check out the [ReactJS Waku Relay guide](/docs/guides/07_reactjs_relay/) to learn how you can use the code above in a React app. 
