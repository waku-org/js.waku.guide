---
title: Poll SDK
date: 2022-01-03T11:00:00+1100
weight: 1
---

# How to Use the Waku Connect Poll SDK

To demonstrate how to use the Waku Connect Poll SDK in your dApp, we will create a TypeScript React app from scratch.

You can then adapt the steps depending on your dApp configuration and build setup.

Only token holders can create & answer polls.
Hence, you need to have an ERC-20 token contract address ready.

The resulting code of this guide can be found at
https://github.com/status-im/wakuconnect-vote-poll-sdk/tree/main/examples/mainnet-poll.

Here is a preview of the end result:

![Poll demo](/assets/poll_sdk/wakuconnect-poll-demo.gif)

After following a dapp creation guide you should have a dapp that can connect to wallet ready. We will continue from this point.

Before starting first add poll packages:

```shell
yarn add \
@waku/poll-sdk-react-components @waku/poll-sdk-react-hooks @waku/vote-poll-sdk-react-components
```

{{< button relref="./01_create-a-poll_button"  >}}Get Started{{< /button >}}
