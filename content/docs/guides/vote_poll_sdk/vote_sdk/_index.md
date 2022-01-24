---
title: Vote SDK
date: 2022-01-06T11:00:00+1100
weight: 1
---

# How to Use the WakuConnect Vote SDK

To demonstrate how to use the WakuConnect Vote SDK in your dApp,
we will create a TypeScript React app from scratch.

You can then adapt the steps depending on your dApp configuration and build setup.

Only token holders can create, vote and finalize proposals.
Hence, you need to have an ERC-20 token contract address ready.

The resulting code of this guide can be found at
TODO.

Here is a preview of the end result:

TODO

After following a dapp creation guide you should have a dapp that can connect to wallet ready. We will continue from this point.

Before starting first add poll packages:

```shell
yarn add \
@waku/vote-sdk-react-components @waku/vote-sdk-react-hooks @waku/vote-poll-sdk-react-components 
```

{{< button relref="./01_deploying_smart_contract"  >}}Get Started{{< /button >}}
