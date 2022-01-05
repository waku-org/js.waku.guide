---
title: Use Cases
date: 2022-01-05T00:00:00+00:00
weight: 3
---

# Use Cases

Waku is a generalized communication network.
It can enable numerous use cases, both person-to-person (e.g. messenger) and machine-to-machine (e.g. state channels).

This is a non-exhaustive list of use cases that we have considered and their current status.

If we are aware of other projects using js-waku and other use cases that could be implemented,
feel free to open a [PR](https://github.com/vacp2p/docs.dappconnect.dev).

Legend:
- _Live_: We are aware of projects who have implemented this use case.
- _SDK Available_: An SDK is available to easily implement this use case.
- _Work In Progress_: We are aware of projects working to implement this use case.
- _Proof of Concept_: A Proof-of-Concept was created, sometimes as part of a hackathon.
- _Idea_: This is an unexplored use case, more research and work may be needed.
---

{{< columns >}}

## Chat Messenger

| _Work In Progress_ |
|--------------------|

Waku can be used as the communication layer to a private, decentralized, censorship-resistant messenger.

- WakuConnect Chat SDK: [repo](https://github.com/status-im/dappconnect-chat-sdk)

<--->

## Polls

| _SDK Available_ |
|-----------------|

Create, answer and view polls which are censorship-resistant.

- WakuConnect Poll SDK:
  [docs](/docs/guides/vote_poll_sdk/#wakuconnect-poll-sdk),
  [repo](https://github.com/status-im/wakuconnect-vote-poll-sdk)

<--->

## NFT Marketplace

| _Live_ |
|--------|

Use Waku to take NFT bids and offers off-chain and save gas.
Add a social media layer, allowing NFT owners to like, comments, etc.

- https://smolpuddle.io/ [repo](https://github.com/Agusx1211/smolpuddle-web)

{{< /columns >}}

---

{{< columns >}}

## State Channels

| _Idea_ |
|--------|

Use Waku to enable two parties to setup and maintain a state channel.

- Discussion: [statechannels.org Discourse](https://statechannels.discourse.group/t/using-waku-as-communication-layer/172/3)

<--->

## Voting and Proposals

| _SDK Available_ |
|-----------------|

For proposals submitted on the blockchain,
exchange votes over Waku to save gas.
Votes can then be aggregated and submitted to the blockchain to commit the result.

Create, answer and view polls which are censorship-resistant.

- WakuConnect Vote SDK:
  [docs](/docs/guides/vote_poll_sdk/#wakuconnect-vote-sdk),
  [repo](https://github.com/status-im/wakuconnect-vote-poll-sdk)

<--->

## Signature Exchange for Multi-Sig Wallets

| _Idea_ |
|--------|

Use Waku to enable several owners of a given multi-sig wallets to exchange signatures in a decentralized,
private & censorship-resistant manner to approve transactions.

{{< /columns >}}

---

{{< columns >}}

## Gameplay Communication

| _Proof of Concept_ |
|--------------------|

Use Waku as the communication layer for a peer-to-peer, decentralize game.
Remove the need of a centralized infrastructure for gameplay communications.

- [Super Card Game](https://github.com/fjij/ethonline-2021)

<--->

## dApp to Wallet Notifications

| _Idea_ |
|--------|

Enable dApp operators and users to send notification directly in user's wallet by integration Waku in both dApps and Wallets.
This could be used to notify governance token holder of an incoming proposal or other in-dApp events.

<--->

## Layer 2 Communication

| _Idea_ |
|--------|

Use Waku as an existing communication network to broadcast and aggregate layer 2 transactions.
Possibly increasing privacy, anonymity and resilience.

{{< /columns >}}

---

{{< columns >}}

## Generalized Marketplace

| _Proof of Concept_ |
|--------------------|

Use Waku to enable users to offer, bid, accept and trade goods and services
to create a ride-sharing or tradings apps.

- Waku-Uber:
  [article](https://hackernoon.com/decentralized-uber-heres-how-i-built-it-with-statusim-waku-and-vuejs),
  [repo](https://github.com/TheBojda/waku-uber)

<--->

{{< /columns >}}
