---
title: Sign Messages Using a Web3 Wallet (EIP-712)
date: 2021-12-09T14:00:00+01:00
weight: 5
---

# Sign Messages Using a Web3 Wallet (EIP-712)

Depending on your use case, you may need users to certify the ownership of their Ethereum account.
They can do so by using their wallet to sign data.

In this guide, we demonstrate how to use the [Ethers.js](https://github.com/ethers-io/ethers.js#readme)
library to request the user to sign typed data ([EIP-712](https://eips.ethereum.org/EIPS/eip-712))
and then broadcast the signature over Waku.

For this guide, we are build a dApp that implements [20/TOY-ETH-PM](https://rfc.vac.dev/spec/20/):
A simple protocols for end-to-end encrypted messages where Ethereum accounts are used as identity.

Alice owns an Ethereum account _A_.
She wants other Ethereum users to find her and contact her using her Ethereum address _A_.
For example, Alice could be the pseudonym creator of an NFT series and wants to open her DMs.

Hence, Alice generates a public key _K_ to be used for encryption purposes.

Alice will need to certify that the public key _K_ can be used to contact her,
the owner of Ethereum address _A_.

## Signing Data

First, you need to determine what data a user must sign.

In our current example, Alice needs to certify that her encryption public key _K_ can be used to contact her,
owner of Ethereum address _A_.

Hence, she will need to sign _K_ using her Ethereum account _A_.

Also, Alice does not want her signature to be used on other dApps,
so she will need to sign some context data, referred to as _domain_ data in the EIP-712 spec.

Hence, the data to sign:

- `name: "My Cool Ethereum Private Message App"`: A unique name to bind the signature to your dApp,
- `version: "1"`: The version of the signature scheme for your dApp,
- `encryptionPublicKey`: The encryption public key of the user,
- `ownerAddress`: The Ethereum address used to sign and owner of the encryption public key,
- `message`: A human-readable message to provide instructions to the user.

Write the following function to build the data to sign.
The data must be formatted as defined in EIP-712:

```ts
function buildMsgParams(
  encryptionPublicKeyHex: string,
  ownerAddressHex: string
) {
  return JSON.stringify({
    domain: {
      name: "My Cool Ethereum Private Message App",
      version: "1",
    },
    message: {
      message:
        "By signing this message you certify that messages addressed to `ownerAddress` must be encrypted with `encryptionPublicKey`",
      encryptionPublicKey: encryptionPublicKeyHex,
      ownerAddress: ownerAddressHex,
    },
    primaryType: "PublishEncryptionPublicKey",
    types: {
      EIP712Domain: [
        { name: "name", type: "string" },
        { name: "version", type: "string" },
      ],
      PublishEncryptionPublicKey: [
        { name: "message", type: "string" },
        { name: "encryptionPublicKey", type: "string" },
        { name: "ownerAddress", type: "string" },
      ],
    },
  });
}
```

The function takes two parameters:

- `encryptionPublicKeyHex`: The public key of the user, as a hex string,
- `ownerAddressHex`: The Ethereum address of the user, as a hex string.

## Sign operation

To sign the data using ethers, define the following function:

```ts
async function signEncryptionKey(
  encryptionPublicKeyHex: string,
  ownerAddressHex: string,
  providerRequest: (request: {
    method: string;
    params?: Array<any>;
  }) => Promise<any>
): Promise<string> {
  const msgParams = buildMsgParams(encryptionPublicKeyHex, ownerAddressHex);

  const result = await providerRequest({
    method: "eth_signTypedData_v4",
    params: [ownerAddressHex, msgParams],
    from: ownerAddressHex,
  });

  return result;
}
```

This function takes 3 arguments:

- `encryptionPublicKeyHex`: Alice's encryption public key _K_,
- `ownerAddressHex`: Alice's Ethereum address,
- `providerRequest`: Ethers' request object.

Instantiate the `providerRequest` when you connect to the wallet.
You can read [Create a DApp](/docs/guides/vote_poll_sdk/dapp_creation/02_connect_wallet/)
to learn how to connect to a wallet.

```ts
import { ethers } from "ethers";

const web3Provider = new ethers.providers.Web3Provider(window.ethereum);
const providerRequest = web3Provider?.provider?.request;
```

`signEncryptionKey` returns the signature in hex format.
You can now add this signature to your Waku payload.

## Send Signature

You can use [Waku Relay to send and receive messages](/docs/guides/02_relay_receive_send_messages/)
or [Waku Light Push to send messages](/docs/guides/06_light_push_send_messages/).

Follow the guides above and replace their [protobuf message definition](/docs/guides/02_relay_receive_send_messages/#protobuf-definition)
with the following:

```protobuf
syntax = "proto3";

message PublicKeyMessage {
  bytes encryptionPublicKey = 1;
  bytes ethAddress = 2;
  bytes signature = 3;
}
```

Note: You can use the [`hexToBytes`](https://js-waku.wakuconnect.dev/modules/utils.html#hexToBytes)
function to convert the signature from hex string to byte array.

## Validate Signature

Users that wishes to encrypt messages for Alice need to ensure that the signature is indeed valid and was generated from
Alice's Ethereum account _A_.

Use the following function to do so:

```ts
import * as sigUtil from "eth-sig-util";
import { keccak256 } from "ethers/lib/utils";
import { utils } from "js-waku";

interface PublicKeyMessage {
  encryptionPublicKey: Uint8Array;
  ethAddress: Uint8Array;
  signature: Uint8Array;
}

function validatePublicKeyMessage(msg: PublicKeyMessage): boolean {
  const recovered = sigUtil.recoverTypedSignature_v4({
    data: JSON.parse(
      buildMsgParams(
        utils.bytesToHex(msg.encryptionPublicKey),
        "0x" + utils.bytesToHex(msg.ethAddress)
      )
    ),
    sig: "0x" + utils.bytesToHex(msg.signature),
  });

  return utils.equalByteArrays(recovered, msg.ethAddress);
}
```

If the function returns `true` then the signature can be trusted and the encryption public key can be used to encrypt messages.

## Conclusion

We reviewed how to use Web3 wallet signature to certify the authenticity of an encryption public key sent over Waku.

The [Ethereum Private Message Web App](/docs/examples/#ethereum-private-message-web-app) example demonstrates this guide.
Relevant code is in the [crypto.ts](https://github.com/status-im/js-waku/blob/master/examples/eth-pm/src/crypto.ts) file.

The WakuConnect Vote Poll SDK implements a [similar logic](https://github.com/status-im/wakuconnect-vote-poll-sdk/blob/60e17d454cbd658bd8fec0aa382b2920e834b4f0/packages/core/src/models/VoteMsg.ts)
where the signature is then used in a [smart contract](https://github.com/status-im/wakuconnect-vote-poll-sdk/blob/60e17d454cbd658bd8fec0aa382b2920e834b4f0/packages/contracts/contracts/VotingContract.sol).
