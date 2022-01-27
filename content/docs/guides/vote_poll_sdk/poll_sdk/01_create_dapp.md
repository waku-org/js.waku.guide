---
title: Create the DApp and Install Dependencies
date: 2022-01-03T11:00:00+1100
weight: 11
---

# Create the DApp and Install Dependencies

## Create React App

Create the new React app using the `typescript` template.
Install the Waku Poll SDK packages.

In this guide, we use [useDApp](https://usedapp.io/) to access the blockchain.

```shell
yarn create react-app poll-dapp-ts --template typescript
cd poll-dapp-ts
yarn add \
@waku/poll-sdk-react-components @waku/poll-sdk-react-hooks @waku/vote-poll-sdk-react-components \
@usedapp/core@0.4.7
yarn add -D @types/styled-components
```

{{< hint warning >}}
`@usedapp/core` must be frozen to version `0.4.7` due to incompatibility between minor versions of `ethers`.

Waku Connect Vote & Poll SDK will be upgraded to the latest version of `@usedapp/core` and `ethers` once `ethereum-waffle`
is released with the [latest version of `ethers`](https://github.com/EthWorks/Waffle/pull/603).
{{< /hint >}}

## Setup polyfills

A number of Web3 dependencies need polyfills.
Said polyfills must be explicitly declared when using webpack 5.

The latest `react-scripts` version uses webpack 5.

We will describe below a method to configure polyfills when using `create-react-app`/`react-scripts` or webpack 5.
This may not be necessary if you do not use `react-scripts` or if you use webpack 4.

Start by installing the polyfill libraries:

```shell
yarn add assert buffer crypto-browserify stream-browserify
```

### Webpack 5

If you directly use webpack 5,
then you can inspire yourself from this [webpack.config.js](https://github.com/status-im/wakuconnect-vote-poll-sdk/blob/main/examples/mainnet-poll/webpack.config.js).

### React-App-Rewired

An alternative is to let `react-scripts` control the webpack 5 config and only override some elements using `react-app-rewired`.

Install `react-app-rewired`:

```shell
yarn add -D react-app-rewired
```

Create a `config-overrides.js` file at the root of your app:

```js
const webpack = require("webpack");

module.exports = (config) => {
  // Override webpack 5 config from react-scripts to load polyfills
  if (!config.resolve) config.resolve = {};
  if (!config.resolve.fallback) config.resolve.fallback = {};
  Object.assign(config.resolve.fallback, {
    buffer: require.resolve("buffer"),
    crypto: require.resolve("crypto-browserify"),
    stream: require.resolve("stream-browserify"),
    assert: require.resolve("assert"),
  });

  if (!config.plugins) config.plugins = [];
  config.plugins.push(
    new webpack.ProvidePlugin({
      Buffer: ["buffer", "Buffer"],
    })
  );

  return config;
};
```

Use `react-app-rewired` in the `package.json`, instead of `react-scripts`:

```
   "scripts": {
-    "start": "react-scripts start",
-    "build": "react-scripts build",
-    "test": "react-scripts test",
-    "eject": "react-scripts eject"
+    "start": "react-app-rewired start",
+    "build": "react-app-rewired build",
+    "test": "react-app-rewired test",
+    "eject": "react-app-rewired eject"
   },
```

## Start development server

You can now start the development server to serve your dApp at http://localhost:3000/ while we code:

```shell
yarn start
```

{{< button relref="./"  >}}Back{{< /button >}}
{{< button relref="./02_connect_wallet"  >}}Next: Connect to the Ethereum Wallet{{< /button >}}
