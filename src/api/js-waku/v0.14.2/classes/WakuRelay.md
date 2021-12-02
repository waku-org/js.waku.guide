[js-waku](../README.md) / [Exports](../modules.md) / WakuRelay

# Class: WakuRelay

Implements the [Waku v2 Relay protocol](https://rfc.vac.dev/spec/11/).
Must be passed as a `pubsub` module to a {Libp2p} instance.

**`implements`** {require('libp2p-interfaces/src/pubsub')}

## Hierarchy

- `Gossipsub`

  ↳ **`WakuRelay`**

## Table of contents

### Constructors

- [constructor](WakuRelay.md#constructor)

### Properties

- [decryptionKeys](WakuRelay.md#decryptionkeys)
- [heartbeat](WakuRelay.md#heartbeat)
- [observers](WakuRelay.md#observers)
- [pubSubTopic](WakuRelay.md#pubsubtopic)

### Methods

- [addDecryptionKey](WakuRelay.md#adddecryptionkey)
- [addObserver](WakuRelay.md#addobserver)
- [deleteDecryptionKey](WakuRelay.md#deletedecryptionkey)
- [deleteObserver](WakuRelay.md#deleteobserver)
- [getPeers](WakuRelay.md#getpeers)
- [send](WakuRelay.md#send)
- [start](WakuRelay.md#start)
- [subscribe](WakuRelay.md#subscribe)

## Constructors

### constructor

• **new WakuRelay**(`libp2p`, `options?`)

#### Parameters

| Name | Type |
| :------ | :------ |
| `libp2p` | `Libp2p` |
| `options?` | `Partial`<`CreateOptions` & `GossipOptions`\> |

#### Overrides

Gossipsub.constructor

#### Defined in

[src/lib/waku_relay/index.ts:78](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L78)

## Properties

### decryptionKeys

• **decryptionKeys**: `Set`<`Uint8Array`\>

#### Defined in

[src/lib/waku_relay/index.ts:68](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L68)

___

### heartbeat

• **heartbeat**: `RelayHeartbeat`

#### Overrides

Gossipsub.heartbeat

#### Defined in

[src/lib/waku_relay/index.ts:65](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L65)

___

### observers

• **observers**: `Object`

observers called when receiving new message.
Observers under key `""` are always called.

#### Index signature

▪ [contentTopic: `string`]: `Set`<(`message`: [`WakuMessage`](WakuMessage.md)) => `void`\>

#### Defined in

[src/lib/waku_relay/index.ts:74](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L74)

___

### pubSubTopic

• **pubSubTopic**: `string`

#### Defined in

[src/lib/waku_relay/index.ts:66](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L66)

## Methods

### addDecryptionKey

▸ **addDecryptionKey**(`key`): `void`

Register a decryption key to attempt decryption of received messages.
This can either be a private key for asymmetric encryption or a symmetric
key. `WakuRelay` will attempt to decrypt messages using both methods.

Strings must be in hex format.

#### Parameters

| Name | Type |
| :------ | :------ |
| `key` | `string` \| `Uint8Array` |

#### Returns

`void`

#### Defined in

[src/lib/waku_relay/index.ts:131](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L131)

___

### addObserver

▸ **addObserver**(`callback`, `contentTopics?`): `void`

Register an observer of new messages received via waku relay

#### Parameters

| Name | Type | Default value | Description |
| :------ | :------ | :------ | :------ |
| `callback` | (`message`: [`WakuMessage`](WakuMessage.md)) => `void` | `undefined` | called when a new message is received via waku relay |
| `contentTopics` | `string`[] | `[]` | Content Topics for which the callback with be called, all of them if undefined, [] or ["",..] is passed. |

#### Returns

`void`

#### Defined in

[src/lib/waku_relay/index.ts:153](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L153)

___

### deleteDecryptionKey

▸ **deleteDecryptionKey**(`key`): `void`

Delete a decryption key that was used to attempt decryption of received
messages.

Strings must be in hex format.

#### Parameters

| Name | Type |
| :------ | :------ |
| `key` | `string` \| `Uint8Array` |

#### Returns

`void`

#### Defined in

[src/lib/waku_relay/index.ts:141](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L141)

___

### deleteObserver

▸ **deleteObserver**(`callback`, `contentTopics?`): `void`

Remove an observer of new messages received via waku relay.
Useful to ensure the same observer is not registered several time
(e.g when loading React components)

#### Parameters

| Name | Type | Default value |
| :------ | :------ | :------ |
| `callback` | (`message`: [`WakuMessage`](WakuMessage.md)) => `void` | `undefined` |
| `contentTopics` | `string`[] | `[]` |

#### Returns

`void`

#### Defined in

[src/lib/waku_relay/index.ts:177](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L177)

___

### getPeers

▸ **getPeers**(): `Set`<`string`\>

Return the relay peers we are connected to and we would publish a message to

#### Returns

`Set`<`string`\>

#### Defined in

[src/lib/waku_relay/index.ts:197](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L197)

___

### send

▸ **send**(`message`): `Promise`<`void`\>

Send Waku message.

#### Parameters

| Name | Type |
| :------ | :------ |
| `message` | [`WakuMessage`](WakuMessage.md) |

#### Returns

`Promise`<`void`\>

#### Defined in

[src/lib/waku_relay/index.ts:119](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L119)

___

### start

▸ **start**(): `void`

Mounts the gossipsub protocol onto the libp2p node
and subscribes to the default topic.

**`override`**

#### Returns

`void`

#### Overrides

Gossipsub.start

#### Defined in

[src/lib/waku_relay/index.ts:108](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L108)

___

### subscribe

▸ **subscribe**(`pubSubTopic`): `void`

Subscribe to a pubsub topic and start emitting Waku messages to observers.

**`override`**

#### Parameters

| Name | Type |
| :------ | :------ |
| `pubSubTopic` | `string` |

#### Returns

`void`

#### Overrides

Gossipsub.subscribe

#### Defined in

[src/lib/waku_relay/index.ts:211](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/index.ts#L211)
