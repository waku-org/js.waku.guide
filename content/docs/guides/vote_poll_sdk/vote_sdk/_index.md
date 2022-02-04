---
title: Vote SDK
date: 2022-01-06T11:00:00+1100
weight: 3
---

# How to Use the Waku Connect Vote SDK

To demonstrate how to use the Waku Connect Vote SDK in your dApp,
we will create a TypeScript React app from scratch.

You can then adapt the steps depending on your dApp configuration and build setup.

Only token holders can create, vote and finalize proposals.
Hence, you need to have an ERC-20 token contract address ready.

The resulting code of this guide can be found in the repo at
[examples/ropsten-voting](https://github.com/status-im/wakuconnect-vote-poll-sdk/tree/master/examples/ropsten-voting).

Here is a preview of the end result:

Create a proposal:
![Proposal creation](/assets/voting_sdk/proposal_creation.gif)

Proposal card:
![Proposal Card](/assets/voting_sdk/proposal_card.png)

After following the [create a dApp guide](../dapp_creation/) you should have a dapp that can connect to wallet ready.
We will continue from this point.

First, add the Vote SDK packages:

```shell
yarn add \
@waku/vote-sdk-react-components @waku/vote-sdk-react-hooks @waku/vote-poll-sdk-react-components 
```

{{< button relref="./01_deploying_smart_contract"  >}}Get Started{{< /button >}}
