---
weight: 100
---
# WakuConnect Vote & Poll SDK

The WakuConnect Vote & Poll SDK enables developers to add Waku powered polling and voting features to their dApp.

The repository can be found on GitHub: https://github.com/status-im/wakuconnect-vote-poll-sdk.

The SDK can be used in two different ways:
to vote (commitment to the blockchain) or poll (no interaction with the blockchain).

For both functionalities, only ERC-20 token holders can create or answer polls/votes.
The developer using the SDK can configure which ERC-20 token contract is used.

## Packages

### Common

- `@waku/vote-poll-sdk-core`: Common libraries to both vote and poll functionalities.
- `@waku/vote-poll-sdk-react-components`: Common React components to both vote and poll functionalities.

### Vote

- `@waku/vote-sdk-react-components`: React components.
- `@waku/vote-sdk-react-hooks`: React hooks.
- `@waku/vote-sdk-contracts`: Solidity contracts.

### Poll

- `@waku/poll-sdk-react-components`: React components.
- `@waku/poll-sdk-react-hooks`: React hooks.

## WakuConnect Vote SDK

The WakuConnect Vote SDK allows you to leverage Waku to save gas fees for most voters.
It uses Waku to broadcast and aggregates votes.
Most token holders will not need to spend gas to vote.

Only the party that starts an election and submit the end results need to interact with the blockchain.

For example, it can be used by a DAO to manage proposals
where proposal creation and vote results must be committed to the blockchain.

With WakuConnect Vote SDK, the DAO could be the one spending gas when creating the proposal and committing the votes, 
whereas the token holders do not spend gas when voting.

### Documentation

{{< hint info >}}
The documentation effort is currently in progress.
It is tracked with [status-im/wakuconnect-vote-poll-sdk#11](https://github.com/status-im/wakuconnect-vote-poll-sdk/issues/11).
Contributions are welcome.
{{< /hint >}}

You can find more information about the Vote SDK's properties in the [README](https://github.com/status-im/wakuconnect-vote-poll-sdk#wakuconnect-vote-sdk).

A working example dApp that includes voting feature can be found in the [repo](https://github.com/status-im/wakuconnect-vote-poll-sdk/tree/main/packages/example).

{{< hint warning >}}
As the example is part of the yarn workspace,
there may be issues with undeclared dependencies with this example.
Tracked with [status-im/wakuconnect-vote-poll-sdk#11](https://github.com/status-im/wakuconnect-vote-poll-sdk/issues/11).
{{< /hint >}}

## WakuConnect Poll SDK

The WakuConnect Poll SDK allows you to leverage Waku and enable token holder to create, answer and view polls.
The polls are not committed to the blockchain and hence do not cost gas.

As the polls use Waku, they do maintain properties expected from dApps: decentralized and censorship-resistant.

The high-level functionality is as follows:

- To create a poll, a token holder sends a message with the poll questions, possible answers and an end time over Waku,
- Other users receive the poll creation message and can view the poll,
  - To avoid spam, only polls created by actual token holders are displayed,
- Any token holder can send their poll answer over Waku,
- Each user cumulates poll responses from Waku and can view them,
  - To avoid spam, only responses sent by actual token holders are displayed.

### Documentation

See [How to Use the WakuConnect Poll SDK](./poll_sdk).
