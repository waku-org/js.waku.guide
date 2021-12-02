[js-waku](../README.md) / [Exports](../modules.md) / WakuStore

# Class: WakuStore

Implements the [Waku v2 Store protocol](https://rfc.vac.dev/spec/13/).

## Table of contents

### Constructors

- [constructor](WakuStore.md#constructor)

### Properties

- [decryptionKeys](WakuStore.md#decryptionkeys)
- [libp2p](WakuStore.md#libp2p)
- [pubSubTopic](WakuStore.md#pubsubtopic)

### Accessors

- [peers](WakuStore.md#peers)
- [randomPeer](WakuStore.md#randompeer)

### Methods

- [addDecryptionKey](WakuStore.md#adddecryptionkey)
- [deleteDecryptionKey](WakuStore.md#deletedecryptionkey)
- [queryHistory](WakuStore.md#queryhistory)

## Constructors

### constructor

• **new WakuStore**(`libp2p`, `options?`)

#### Parameters

| Name | Type |
| :------ | :------ |
| `libp2p` | `Libp2p` |
| `options?` | `CreateOptions` |

#### Defined in

[src/lib/waku_store/index.ts:101](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_store/index.ts#L101)

## Properties

### decryptionKeys

• **decryptionKeys**: `Set`<`Uint8Array`\>

#### Defined in

[src/lib/waku_store/index.ts:99](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_store/index.ts#L99)

___

### libp2p

• **libp2p**: `Libp2p`

___

### pubSubTopic

• **pubSubTopic**: `string`

#### Defined in

[src/lib/waku_store/index.ts:98](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_store/index.ts#L98)

## Accessors

### peers

• `get` **peers**(): `Peer`[]

Returns known peers from the address book (`libp2p.peerStore`) that support
store protocol. Waku may or  may not be currently connected to these peers.

#### Returns

`Peer`[]

#### Defined in

[src/lib/waku_store/index.ts:269](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_store/index.ts#L269)

___

### randomPeer

• `get` **randomPeer**(): `undefined` \| `Peer`

Returns a random peer that supports store protocol from the address
book (`libp2p.peerStore`). Waku may or  may not be currently connected to
this peer.

#### Returns

`undefined` \| `Peer`

#### Defined in

[src/lib/waku_store/index.ts:278](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_store/index.ts#L278)

## Methods

### addDecryptionKey

▸ **addDecryptionKey**(`key`): `void`

Register a decryption key to attempt decryption of messages received in any
subsequent [queryHistory](WakuStore.md#queryhistory) call. This can either be a private key for
asymmetric encryption or a symmetric key. [WakuStore](WakuStore.md) will attempt to
decrypt messages using both methods.

Strings must be in hex format.

#### Parameters

| Name | Type |
| :------ | :------ |
| `key` | `string` \| `Uint8Array` |

#### Returns

`void`

#### Defined in

[src/lib/waku_store/index.ts:251](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_store/index.ts#L251)

___

### deleteDecryptionKey

▸ **deleteDecryptionKey**(`key`): `void`

Delete a decryption key that was used to attempt decryption of messages
received in subsequent [queryHistory](WakuStore.md#queryhistory) calls.

Strings must be in hex format.

#### Parameters

| Name | Type |
| :------ | :------ |
| `key` | `string` \| `Uint8Array` |

#### Returns

`void`

#### Defined in

[src/lib/waku_store/index.ts:261](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_store/index.ts#L261)

___

### queryHistory

▸ **queryHistory**(`contentTopics`, `options?`): `Promise`<[`WakuMessage`](WakuMessage.md)[]\>

Do a History Query to a Waku Store.

**`throws`** If not able to reach a Waku Store peer to query
or if an error is encountered when processing the reply.

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `contentTopics` | `string`[] | The content topics to pass to the query, leave empty to retrieve all messages. |
| `options?` | `QueryOptions` | - |

#### Returns

`Promise`<[`WakuMessage`](WakuMessage.md)[]\>

#### Defined in

[src/lib/waku_store/index.ts:120](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_store/index.ts#L120)
