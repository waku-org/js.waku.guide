---
title: Receive and Send Messages Using Waku Relay With ReactJS
date: 2021-12-09T14:00:00+01:00
weight: 70
---

# Receive and Send Messages Using Waku Relay With ReactJS

It is easy to use Waku Connect with ReactJS.
In this guide, we will demonstrate how your ReactJS dApp can use Waku Relay to send and receive messages.

Before starting, you need to choose a _Content Topic_ for your dApp.
Check out the [how to choose a content topic guide](/docs/guides/01_choose_content_topic/) to learn more about content topics.
For this guide, we are using a single content topic: `/min-react-js-chat/1/chat/proto`.

# Setup

Create a new React app:

```shell
npx create-react-app relay-reactjs-chat
cd relay-reactjs-chat
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
npm install --save assert buffer crypto-browserify process stream-browserify
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
const webpack = require("webpack");

module.exports = {
  dev: (config) => {
    // Override webpack 5 config from react-scripts to load polyfills
    if (!config.resolve) config.resolve = {};
    if (!config.resolve.fallback) config.resolve.fallback = {};
    Object.assign(config.resolve.fallback, {
      buffer: require.resolve("buffer"),
      crypto: require.resolve("crypto-browserify"),
      stream: require.resolve("stream-browserify"),
    });

    if (!config.plugins) config.plugins = [];
    config.plugins.push(
      new webpack.DefinePlugin({
        "process.env.ENV": JSON.stringify("dev"),
      })
    );
    config.plugins.push(
      new webpack.ProvidePlugin({
        process: "process/browser.js",
        Buffer: ["buffer", "Buffer"],
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
      buffer: require.resolve("buffer"),
      crypto: require.resolve("crypto-browserify"),
      stream: require.resolve("stream-browserify"),
    });

    if (!config.plugins) config.plugins = [];
    config.plugins.push(
      new webpack.DefinePlugin({
        "process.env.ENV": JSON.stringify("prod"),
      })
    );
    config.plugins.push(
      new webpack.ProvidePlugin({
        process: "process/browser.js",
        Buffer: ["buffer", "Buffer"],
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
npm install --save js-waku
```

Start the dev server and open the dApp in your browser:

```shell
npm run start
```

# Create Waku Instance

In order to interact with the Waku network, you first need a Waku instance.
Go to `App.js` and modify the `App` function:

```js
import { Waku } from "js-waku";
import * as React from "react";

function App() {
  const [waku, setWaku] = React.useState(undefined);
  const [wakuStatus, setWakuStatus] = React.useState("None");

  // Start Waku
  React.useEffect(() => {
    // If Waku is already assigned, the job is done
    if (!!waku) return;
    // If Waku status not None, it means we are already starting Waku
    if (wakuStatus !== "None") return;

    setWakuStatus("Starting");

    // Create Waku
    Waku.create({ bootstrap: { default: true } }).then((waku) => {
      // Once done, put it in the state
      setWaku(waku);
      // And update the status
      setWakuStatus("Started");
    });
  }, [waku, wakuStatus]);

  return (
    <div className="App">
      <header className="App-header">
        <p>Waku node's status: {wakuStatus}</p>
      </header>
    </div>
  );
}

export default App;
```

# Wait to be connected

When using the `bootstrap` option, it may take some time to connect to other peers.
To ensure that you have relay peers available to send and receive messages,
use the `Waku.waitForRemotePeer()` async function:

```js
React.useEffect(() => {
  if (!!waku) return;
  if (wakuStatus !== "None") return;

  setWakuStatus("Starting");

  Waku.create({ bootstrap: { default: true } }).then((waku) => {
    setWaku(waku);
    setWakuStatus("Connecting");
    waku.waitForRemotePeer().then(() => {
      setWakuStatus("Ready");
    });
  });
}, [waku, wakuStatus]);
```

# Define Message Format

To define the Protobuf message format,
you can use [protobufjs](https://www.npmjs.com/package/protobufjs):

```shell
npm install protobufjs
```

Define `SimpleChatMessage` with two fields: `timestamp` and `text`.

```js
import protobuf from "protobufjs";

const SimpleChatMessage = new protobuf.Type("SimpleChatMessage")
    .add(new protobuf.Field("timestamp", 1, "uint64"))
    .add(new protobuf.Field("text", 2, "string"));
```

# Send Messages

Create a function that takes the Waku instance and a message to send:

```js
import {WakuMessage} from "js-waku";

const ContentTopic = `/relay-reactjs-chat/1/chat/proto`;

function sendMessage(message, waku, timestamp) {
    const time = timestamp.getTime();

    // Encode to protobuf
    const protoMsg = SimpleChatMessage.create({
        timestamp: time,
        text: message,
    });
    const payload = SimpleChatMessage.encode(protoMsg).finish();

    // Wrap in a Waku Message
    return WakuMessage.fromBytes(payload, ContentTopic).then((wakuMessage) =>
        // Send over Waku Relay
        waku.relay.send(wakuMessage)
    );
}
```

Then, add a button to the `App` function:

```js
function App() {
  const [waku, setWaku] = React.useState(undefined);
  const [wakuStatus, setWakuStatus] = React.useState("None");
  // Using a counter just for the messages to be different
  const [sendCounter, setSendCounter] = React.useState(0);

  React.useEffect(() => {
    // ... creates Waku
  }, [waku, wakuStatus]);

  const sendMessageOnClick = () => {
    // Check Waku is started and connected first.
    if (wakuStatus !== "Ready") return;

    sendMessage(`Here is message #${sendCounter}`, waku, new Date()).then(() =>
      console.log("Message sent")
    );

    // For demonstration purposes.
    setSendCounter(sendCounter + 1);
  };

  return (
    <div className="App">
      <header className="App-header">
        <p>{wakuStatus}</p>
        <button onClick={sendMessageOnClick} disabled={wakuStatus !== "Ready"}>
          Send Message
        </button>
      </header>
    </div>
  );
}
```

# Receive Messages

To process incoming messages, you need to register an observer on Waku Relay.
First, you need to define the observer function.

You will need to remove the observer when the component unmount.
Hence, you need the reference to the function to remain the same.
For that, use `React.useCallback`:

```js
const processIncomingMessage = React.useCallback((wakuMessage) => {
    // Empty message?
    if (!wakuMessage.payload) return;

    // Decode the protobuf payload
    const {text, timestamp} = SimpleChatMessage.decode(wakuMessage.payload);

    const time = new Date();
    time.setTime(timestamp);

    // For now, just log new messages on the console
    console.log(`message received at ${time.toString()}: ${text}`);
}, []);
```

Then, add this observer to Waku Relay.
Do not forget to delete the observer is the component is being unmounted:

```js
React.useEffect(() => {
  if (!waku) return;

  // Pass the content topic to only process messages related to your dApp
  waku.relay.addObserver(processIncomingMessage, [ContentTopic]);

  // `cleanUp` is called when the component is unmounted, see ReactJS doc.
  return function cleanUp() {
    waku.relay.deleteObserver(processIncomingMessage, [ContentTopic]);
  };
}, [waku, wakuStatus, processIncomingMessage]);
```

# Display Messages

The Waku work is now done.
Your dApp is able to send and receive messages using Waku.
For the sake of completeness, let's display received messages on the page.

First, add incoming messages to the state of the `App` component:

```js
function App() {
    //...

    const [messages, setMessages] = React.useState([]);

    const processIncomingMessage = React.useCallback((wakuMessage) => {
        if (!wakuMessage.payload) return;

        const {text, timestamp} = SimpleChatMessage.decode(wakuMessage.payload);

        const time = new Date();
        time.setTime(timestamp);
        const message = {text, timestamp: time};

        setMessages((messages) => {
            return [message].concat(messages);
        });
    }, []);

    // ...
}
```

Then, render the messages:

```js
function App() {
  // ...

  return (
    <div className="App">
      <header className="App-header">
        <p>{wakuStatus}</p>
        <button onClick={sendMessageOnClick} disabled={wakuStatus !== "Ready"}>
          Send Message
        </button>
        <ul>
          {messages.map((msg) => {
            return (
              <li>
                <p>
                  {msg.timestamp.toString()}: {msg.text}
                </p>
              </li>
            );
          })}
        </ul>
      </header>
    </div>
  );
}
```

And Voilà! You should now be able to send and receive messages.
Try out by opening the app from different browsers.

You can see the complete code in the [Relay ReactJS Chat Example App](https://github.com/status-im/js-waku/tree/main/examples/relay-reactjs-chat).
