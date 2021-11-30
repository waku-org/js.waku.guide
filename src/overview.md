# JS-Waku Overview

In this section you will learn how what are js-waku's key API and how to use them.

To learn more about a specific API, you can refer to the [API documentation]().

Our [guides](guides) provide more detailed explanation of some Waku functionality and how they can be used with popular web frameworks.

## Installation

Install `js-waku` package:

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
Depending on your use case, you can either create one (or several) new `contentTopic`(s) or look at the [RFCs](https://rfc.vac.dev/) and use an existing `contentTopic`.
See [How to Choose a Content Topic](guides/choose_content_topic.md) for more details.

For example, if you were to use a new `contentTopic` such as `/my-cool-app/1/my-use-case/proto`,
here is how to listen to new messages received via [Waku v2 Relay](https://rfc.vac.dev/spec/11/):

```ts
waku.relay.addObserver((msg) => {
  console.log("Message received:", msg.payloadAsUtf8)
}, ["/my-cool-app/1/my-use-case/proto"]);
```

### Send messages

There are two ways to send messages:

#### Waku Relay

[Waku Relay](https://rfc.vac.dev/spec/11/) is the most decentralized option,
peer receiving your messages are unlikely to know whether you are the originator or simply forwarding them.
However, it does not give you any delivery information.

```ts
import { WakuMessage } from 'js-waku';

const msg = await WakuMessage.fromUtf8String("Here is a message!", "/my-cool-app/1/my-use-case/proto")
await waku.relay.send(msg);
```

#### Waku Light Push

[Waku Light Push](https://rfc.vac.dev/spec/19/) gives you confirmation that the light push server node has
received your message.
However, it means that said node knows you are the originator of the message.
It cannot guarantee that the node will forward the message.

```ts
const ack = await waku.lightPush.push(message);
if (!ack?.isSuccess) {
  // Message was not sent
}
```

### Retrieve archived messages

The [Waku v2 Store protocol](https://rfc.vac.dev/spec/13/) enables more permanent nodes to store messages received via relay
and ephemeral clients to retrieve them (e.g. mobile phone resuming connectivity).
The protocol implements pagination meaning that it may take several queries to retrieve all messages.

Query a waku store peer to check historical messages:

```ts
// Process messages once they are all retrieved
const messages = await waku.store.queryHistory(['/my-cool-app/1/my-use-case/proto']);
messages.forEach((msg) => {
  console.log('Message retrieved:', msg.payloadAsUtf8);
});

// Or, pass a callback function to be executed as pages are received:
waku.store.queryHistory(['/my-cool-app/1/my-use-case/proto'], {
  callback: (messages) => {
    messages.forEach((msg) => {
      console.log('Message retrieved:', msg.payloadAsUtf8);
    });
  }
});
```
