---
title: Retrieve Messages Using Waku Store With ReactJS
date: 2021-12-09T14:00:00+01:00
weight: 8
---
# Retrieve Messages Using Waku Store With ReactJS

It is easy to use WakuConnect with ReactJS.
In this guide, we will demonstrate how your ReactJS dApp can use Waku Store to retrieve messages.

DApps running on a phone or in a browser are often offline:
The browser could be closed or mobile app in the background.

[Waku Relay](https://rfc.vac.dev/spec/18/) is a gossip protocol.
As a user, it means that your peers forward you messages they just received.
If you cannot be reached by your peers, then messages are not relayed;
relay peers do **not** save messages for later.

However, [Waku Store](https://rfc.vac.dev/spec/13/) peers do save messages they relay,
allowing you to retrieve them at a later time.
The Waku Store protocol is best-effort and does not guarantee data availability.
Waku Relay should still be preferred when online;
Waku Store can be used after resuming connectivity:
For example, when the dApp starts.

In this guide, we'll review how you can use Waku Store to retrieve messages.

Before starting, you need to choose a _Content Topic_ for your dApp.
Check out the [how to choose a content topic guide](/docs/guides/01_choose_content_topic/) to learn more about content topics.

# Setup

Create a new React app:

```shell
npx create-react-app store-reactjs-chat
cd store-reactjs-chat
```

## `BigInt`

Some of js-waku's dependencies use [`BigInt`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt)
that is [only supported by modern browsers](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt#browser_compatibility).

To ensure that `react-scripts` properly transpile your webapp code, update the `package.json` file:

```json
{
  "browserslist": {
    "production": [
      ">0.2%",
      "not ie <= 99",
      "not android <= 4.4.4",
      "not dead",
      "not op_mini all"
    ]
  }
}
```

## Setup polyfills

A number of Web3 dependencies need polyfills.
Said polyfills must be explicitly declared when using webpack 5.

The latest `react-scripts` version uses webpack 5.

We will describe below a method to configure polyfills when using `create-react-app`/`react-scripts` or webpack 5.
This may not be necessary if you do not use `react-scripts` or if you use webpack 4.

Start by installing the polyfill libraries:

```shell
npm install assert buffer crypto-browserify stream-browserify
```

### Webpack 5

If you directly use webpack 5,
then you can inspire yourself from this [webpack.config.js](https://github.com/status-im/wakuconnect-vote-poll-sdk/blob/main/examples/mainnet-poll/webpack.config.js).

### cra-webpack-rewired

An alternative is to let `react-scripts` control the webpack 5 config and only override some elements using `cra-webpack-rewired`.

Install `cra-webpack-rewired`:

```shell
npm install -D cra-webpack-rewired
```

Create a `config/webpack.extend.js` file at the root of your app:

```js
const webpack = require('webpack');

module.exports = {
    dev: (config) => {
        // Override webpack 5 config from react-scripts to load polyfills
        if (!config.resolve) config.resolve = {};
        if (!config.resolve.fallback) config.resolve.fallback = {};
        Object.assign(config.resolve.fallback, {
            buffer: require.resolve('buffer'),
            crypto: require.resolve('crypto-browserify'),
            stream: require.resolve('stream-browserify'),
        });

        if (!config.plugins) config.plugins = [];
        config.plugins.push(
            new webpack.DefinePlugin({
                'process.env.ENV': JSON.stringify('dev'),
            })
        );
        config.plugins.push(
            new webpack.ProvidePlugin({
                process: 'process/browser.js',
                Buffer: ['buffer', 'Buffer'],
            })
        );

        if (!config.ignoreWarnings) config.ignoreWarnings = [];
        config.ignoreWarnings.push(/Failed to parse source map/);

        return config;
    },
    prod: (config) => {
        // Override webpack 5 config from react-scripts to load polyfills
        if (!config.resolve) config.resolve = {};
        if (!config.resolve.fallback) config.resolve.fallback = {};
        Object.assign(config.resolve.fallback, {
            buffer: require.resolve('buffer'),
            crypto: require.resolve('crypto-browserify'),
            stream: require.resolve('stream-browserify'),
        });

        if (!config.plugins) config.plugins = [];
        config.plugins.push(
            new webpack.DefinePlugin({
                'process.env.ENV': JSON.stringify('prod'),
            })
        );
        config.plugins.push(
            new webpack.ProvidePlugin({
                process: 'process/browser.js',
                Buffer: ['buffer', 'Buffer'],
            })
        );

        if (!config.ignoreWarnings) config.ignoreWarnings = [];
        config.ignoreWarnings.push(/Failed to parse source map/);

        return config;
    },
};
```

Use `cra-webpack-rewired` in the `package.json`, instead of `react-scripts`:

```
   "scripts": {
-    "start": "react-scripts start",
-    "build": "react-scripts build",
-    "test": "react-scripts test",
-    "eject": "react-scripts eject"
+    "start": "cra-webpack-rewired start",
+    "build": "cra-webpack-rewired build",
+    "test": "cra-webpack-rewired test",
+    "eject": "cra-webpack-rewired eject"
   },
```

Then, install [js-waku](https://npmjs.com/package/js-waku):

```shell
npm install js-waku
```

Start the dev server and open the dApp in your browser:

```shell
npm run start
```

{{< hint info >}}
We have noticed some [issues](https://github.com/status-im/js-waku/issues/165) with React bundling due to `npm` pulling an old version of babel.
If you are getting an error about the [optional chaining (?.)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining)
character not being valid, try cleaning up and re-installing your dependencies:

```shell
rm -rf node_modules package-lock.json
npm install
```
{{< /hint >}}

# Create Waku Instance

In order to interact with the Waku network, you first need a Waku instance.
Go to `App.js` and modify the `App` function:

```js
import {Waku} from 'js-waku';
import * as React from 'react';

function App() {
    const [waku, setWaku] = React.useState(undefined);
    const [wakuStatus, setWakuStatus] = React.useState('None');

    // Start Waku
    React.useEffect(() => {
        // If Waku status not None, it means we are already starting Waku 
        if (wakuStatus !== 'None') return;

        setWakuStatus('Starting');

        // Create Waku
        Waku.create({bootstrap: {default: true}}).then((waku) => {
            // Once done, put it in the state
            setWaku(waku);
            // And update the status
            setWakuStatus('Connecting');
        });
    }, [waku, wakuStatus]);

    return (
        <div className='App'>
            <header className='App-header'>
                <p>{wakuStatus}</p>
            </header>
        </div>
    );
}

export default App;
```

# Wait to be connected

When using the `bootstrap` option, it may take some time to connect to other peers.
To ensure that you have store peers available to retrieve messages from,
use the `Waku.waitForConnectedPeer()` async function:

```js
React.useEffect(() => {
  if (!waku) return;

  if (wakuStatus === 'Connected') return;

  waku.waitForConnectedPeer().then(() => {
    setWakuStatus('Connected');
  });
}, [waku, wakuStatus]);
```

# Use Protobuf

Waku v2 protocols use [protobuf](https://developers.google.com/protocol-buffers/) [by default](https://rfc.vac.dev/spec/10/).

Let's review how you can use protobuf to decode structured data.

First, define a data structure.
For this guide, we will use a simple chat message that contains a timestamp, nick and text:

```js
{
  timestamp: Date;
  nick: string;
  text: string;
}
```

To encode and decode protobuf payloads, you can use the [protons](https://www.npmjs.com/package/protons) package.

## Install Protobuf Library

```shell
npm install protons
```

## Protobuf Definition

Define the data structure with protons:

```js
import protons from 'protons';

const proto = protons(`
message ChatMessage {
  uint64 timestamp = 1;
  string nick = 2;
  bytes text = 3;
}
`);
```

You can learn about protobuf message definitions here:
[Protocol Buffers Language Guide](https://developers.google.com/protocol-buffers/docs/proto).

## Decode Messages

To decode the messages retrieved from a Waku Store node,
you need to extract the protobuf payload and decode it using `protons`.

```js
function decodeMessage(wakuMessage) {
  if (!wakuMessage.payload) return;

  const { timestamp, nick, text } = proto.ChatMessage.decode(
    wakuMessage.payload
  );

  // All fields in protobuf are optional so be sure to check
  if (!timestamp || !text || !nick) return;

  const time = new Date();
  time.setTime(timestamp);

  const utf8Text = Buffer.from(text).toString('utf-8');

  return { text: utf8Text, timestamp: time, nick };
}

```

## Retrieve messages

You now have all the building blocks to retrieve and decode messages for a store node.

Note that Waku Store queries are paginated.
The API provided by `js-waku` automatically traverses all pages of the Waku Store response.
By default, the most recent page is retrieved first but this can be changed with the `pageDirection` option.

First, define a React state to save the messages:

```js
function App() {
  const [messages, setMessages] = React.useState([]);
  /// [..]
}
```

Then, define `processMessages` to decode and then store messages in the React state.
You will pass `processMessages` as a `callback` option to `WakuStore.queryHistory`.
`processMessages` will be called each time a page is received from the Waku Store.

```js
const processMessages = (retrievedMessages) => {
  const messages = retrievedMessages.map(decodeMessage).filter(Boolean);

  setMessages((currentMessages) => {
    return currentMessages.concat(messages.reverse());
  });
};
```

Pass `processMessage` in `WakuStore.queryHistory` as the `callback` value:

```js
waku.store
  .queryHistory([ContentTopic], { callback: processMessages });
```

Finally, create a `Messages` component to render the messages:

```tsx
function Messages(props) {
    return props.messages.map(({ text, timestamp, nick }) => {
        return (
            <li>
                ({formatDate(timestamp)}) {nick}: {text}
            </li>
        );
    });
}

function formatDate(timestamp) {
    return timestamp.toLocaleString([], {
        month: 'short',
        day: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
        second: '2-digit',
        hour12: false,
    });
}
```

Use `Messages` in the `App` function:

```tsx
function App() {
  // [..]

  return (
    <div className='App'>
      <header className='App-header'>
        <h2>{wakuStatus}</h2>
        <h3>Messages</h3>
        <ul>
          <Messages messages={messages} />
        </ul>
      </header>
    </div>
  );
}
```

All together, you should now have:

```js
import {Waku} from 'js-waku';
import * as React from 'react';
import protons from 'protons';

const ContentTopic = '/toy-chat/2/huilong/proto';

const proto = protons(`
message ChatMessage {
  uint64 timestamp = 1;
  string nick = 2;
  bytes text = 3;
}
`);

function App() {
    const [waku, setWaku] = React.useState(undefined);
    const [wakuStatus, setWakuStatus] = React.useState('None');
    const [messages, setMessages] = React.useState([]);

    // Start Waku
    React.useEffect(() => {
        // If Waku status not None, it means we are already starting Waku
        if (wakuStatus !== 'None') return;

        setWakuStatus('Starting');

        // Create Waku
        Waku.create({bootstrap: {default: true}}).then((waku) => {
            // Once done, put it in the state
            setWaku(waku);
            // And update the status
            setWakuStatus('Connecting');
        });
    }, [waku, wakuStatus]);


    React.useEffect(() => {
        if (!waku) return;

        if (wakuStatus === 'Connected') return;

        waku.waitForConnectedPeer().then(() => {
            setWakuStatus('Connected');
        });
    }, [waku, wakuStatus]);

    React.useEffect(() => {
        if (wakuStatus !== 'Connected') return;

        const processMessages = (retrievedMessages) => {
            const messages = retrievedMessages.map(decodeMessage).filter(Boolean);

            setMessages((currentMessages) => {
                return currentMessages.concat(messages.reverse());
            });
        };

        waku.store
            .queryHistory([ContentTopic], {callback: processMessages})
            .catch((e) => {
                console.log('Failed to retrieve messages', e);
            });
    }, [waku, wakuStatus]);

    return (
        <div className='App'>
            <header className='App-header'>
                <h2>{wakuStatus}</h2>
                <h3>Messages</h3>
                <ul>
                    <Messages messages={messages}/>
                </ul>
            </header>
        </div>
    );
}

export default App;

function decodeMessage(wakuMessage) {
    if (!wakuMessage.payload) return;

    const {timestamp, nick, text} = proto.ChatMessage.decode(
        wakuMessage.payload
    );

    // All fields in protobuf are optional so be sure to check
    if (!timestamp || !text || !nick) return;

    const time = new Date();
    time.setTime(timestamp);

    const utf8Text = Buffer.from(text).toString('utf-8');

    return {text: utf8Text, timestamp: time, nick};
}

function Messages(props) {
    return props.messages.map(({text, timestamp, nick}) => {
        return (
            <li>
                ({formatDate(timestamp)}) {nick}: {text}
            </li>
        );
    });
}

function formatDate(timestamp) {
    return timestamp.toLocaleString([], {
        month: 'short',
        day: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
        second: '2-digit',
        hour12: false,
    });
}
```

Note that `WakuStore.queryHistory` select an available store node for you.
However, it can only select a connected node, which is why the bootstrapping is necessary.
It will throw an error if no store node is available.

If no message are returned,
then you can use https://status-im.github.io/js-waku/ to send some messages on the
toy chat topic and refresh your app.

## Filter messages by send time

By default, Waku Store nodes store messages for 30 days.
Depending on your use case, you may not need to retrieve 30 days worth of messages.

[Waku Message](https://rfc.vac.dev/spec/14/) defines an optional unencrypted `timestamp` field.
The timestamp is set by the sender.
By default, js-waku sets the timestamp of outgoing message to the current time.

You can filter messages that include a timestamp within given bounds with the `timeFilter` option.

Retrieve messages up to a week old:

```js
const startTime = new Date();
// 7 days/week, 24 hours/day, 60min/hour, 60secs/min, 100ms/sec
startTime.setTime(startTime.getTime() - 7 * 24 * 60 * 60 * 1000);

waku.store
  .queryHistory([ContentTopic], {
    callback: processMessages,
    timeFilter: { startTime, endTime: new Date() }
  });
```

## End result

You can see the complete code in the [Minimal ReactJS Waku Store App](https://github.com/status-im/js-waku/tree/main/examples/store-reactjs-chat).
