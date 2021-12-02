[js-waku](../README.md) / [Exports](../modules.md) / Waku

# Class: Waku

## Table of contents

### Constructors

- [constructor](Waku.md#constructor)

### Properties

- [libp2p](Waku.md#libp2p)
- [lightPush](Waku.md#lightpush)
- [pingKeepAliveTimers](Waku.md#pingkeepalivetimers)
- [relay](Waku.md#relay)
- [relayKeepAliveTimers](Waku.md#relaykeepalivetimers)
- [store](Waku.md#store)

### Methods

- [addDecryptionKey](Waku.md#adddecryptionkey)
- [addPeerToAddressBook](Waku.md#addpeertoaddressbook)
- [deleteDecryptionKey](Waku.md#deletedecryptionkey)
- [dial](Waku.md#dial)
- [getLocalMultiaddrWithID](Waku.md#getlocalmultiaddrwithid)
- [startKeepAlive](Waku.md#startkeepalive)
- [stop](Waku.md#stop)
- [stopKeepAlive](Waku.md#stopkeepalive)
- [waitForConnectedPeer](Waku.md#waitforconnectedpeer)
- [create](Waku.md#create)

## Constructors

### constructor

• `Private` **new Waku**(`options`, `libp2p`, `store`, `lightPush`)

#### Parameters

| Name | Type |
| :------ | :------ |
| `options` | `CreateOptions` |
| `libp2p` | `Libp2p` |
| `store` | [`WakuStore`](WakuStore.md) |
| `lightPush` | [`WakuLightPush`](WakuLightPush.md) |

#### Defined in

[src/lib/waku.ts:114](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L114)

## Properties

### libp2p

• **libp2p**: `Libp2p`

#### Defined in

[src/lib/waku.ts:102](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L102)

___

### lightPush

• **lightPush**: [`WakuLightPush`](WakuLightPush.md)

#### Defined in

[src/lib/waku.ts:105](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L105)

___

### pingKeepAliveTimers

• `Private` **pingKeepAliveTimers**: `Object`

#### Index signature

▪ [peer: `string`]: `ReturnType`<typeof `setInterval`\>

#### Defined in

[src/lib/waku.ts:107](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L107)

___

### relay

• **relay**: [`WakuRelay`](WakuRelay.md)

#### Defined in

[src/lib/waku.ts:103](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L103)

___

### relayKeepAliveTimers

• `Private` **relayKeepAliveTimers**: `Object`

#### Index signature

▪ [peer: `string`]: `ReturnType`<typeof `setInterval`\>

#### Defined in

[src/lib/waku.ts:110](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L110)

___

### store

• **store**: [`WakuStore`](WakuStore.md)

#### Defined in

[src/lib/waku.ts:104](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L104)

## Methods

### addDecryptionKey

▸ **addDecryptionKey**(`key`): `void`

Register a decryption key to attempt decryption of messages received via
[WakuRelay](WakuRelay.md) and [WakuStore](WakuStore.md). This can either be a private key for
asymmetric encryption or a symmetric key.

Strings must be in hex format.

#### Parameters

| Name | Type |
| :------ | :------ |
| `key` | `string` \| `Uint8Array` |

#### Returns

`void`

#### Defined in

[src/lib/waku.ts:285](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L285)

___

### addPeerToAddressBook

▸ **addPeerToAddressBook**(`peerId`, `multiaddrs`): `void`

Add peer to address book, it will be auto-dialed in the background.

#### Parameters

| Name | Type |
| :------ | :------ |
| `peerId` | `string` \| `PeerId` |
| `multiaddrs` | `string`[] \| `Multiaddr`[] |

#### Returns

`void`

#### Defined in

[src/lib/waku.ts:254](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L254)

___

### deleteDecryptionKey

▸ **deleteDecryptionKey**(`key`): `void`

Delete a decryption key that was used to attempt decryption of messages
received via [WakuRelay](WakuRelay.md) or [WakuStore](WakuStore.md).

Strings must be in hex format.

#### Parameters

| Name | Type |
| :------ | :------ |
| `key` | `string` \| `Uint8Array` |

#### Returns

`void`

#### Defined in

[src/lib/waku.ts:296](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L296)

___

### dial

▸ **dial**(`peer`): `Promise`<{ `protocol`: `string` ; `stream`: `MuxedStream`  }\>

Dials to the provided peer.

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `peer` | `string` \| `PeerId` \| `Multiaddr` | The peer to dial |

#### Returns

`Promise`<{ `protocol`: `string` ; `stream`: `MuxedStream`  }\>

#### Defined in

[src/lib/waku.ts:244](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L244)

___

### getLocalMultiaddrWithID

▸ **getLocalMultiaddrWithID**(): `string`

Return the local multiaddr with peer id on which libp2p is listening.

**`throws`** if libp2p is not listening on localhost

#### Returns

`string`

#### Defined in

[src/lib/waku.ts:305](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L305)

___

### startKeepAlive

▸ `Private` **startKeepAlive**(`peerId`, `pingPeriodSecs`, `relayPeriodSecs`): `void`

#### Parameters

| Name | Type |
| :------ | :------ |
| `peerId` | `PeerId` |
| `pingPeriodSecs` | `number` |
| `relayPeriodSecs` | `number` |

#### Returns

`void`

#### Defined in

[src/lib/waku.ts:354](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L354)

___

### stop

▸ **stop**(): `Promise`<`void`\>

#### Returns

`Promise`<`void`\>

#### Defined in

[src/lib/waku.ts:274](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L274)

___

### stopKeepAlive

▸ `Private` **stopKeepAlive**(`peerId`): `void`

#### Parameters

| Name | Type |
| :------ | :------ |
| `peerId` | `PeerId` |

#### Returns

`void`

#### Defined in

[src/lib/waku.ts:379](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L379)

___

### waitForConnectedPeer

▸ **waitForConnectedPeer**(): `Promise`<`void`\>

Wait to be connected to a peer. Useful when using the [[CreateOptions.bootstrap]]
with [Waku.create](Waku.md#create). The Promise resolves only once we are connected to a
Store peer, Relay peer and Light Push peer.

#### Returns

`Promise`<`void`\>

#### Defined in

[src/lib/waku.ts:320](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L320)

___

### create

▸ `Static` **create**(`options?`): `Promise`<[`Waku`](Waku.md)\>

Create new waku node

#### Parameters

| Name | Type | Description |
| :------ | :------ | :------ |
| `options?` | `CreateOptions` | Takes the same options than `Libp2p`. |

#### Returns

`Promise`<[`Waku`](Waku.md)\>

#### Defined in

[src/lib/waku.ts:148](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L148)
