[js-waku](../README.md) / [Exports](../modules.md) / WakuLightPush

# Class: WakuLightPush

Implements the [Waku v2 Light Push protocol](https://rfc.vac.dev/spec/19/).

## Table of contents

### Constructors

- [constructor](WakuLightPush.md#constructor)

### Properties

- [libp2p](WakuLightPush.md#libp2p)
- [pubSubTopic](WakuLightPush.md#pubsubtopic)

### Accessors

- [peers](WakuLightPush.md#peers)
- [randomPeer](WakuLightPush.md#randompeer)

### Methods

- [push](WakuLightPush.md#push)

## Constructors

### constructor

• **new WakuLightPush**(`libp2p`, `options?`)

#### Parameters

| Name | Type |
| :------ | :------ |
| `libp2p` | `Libp2p` |
| `options?` | `CreateOptions` |

#### Defined in

[src/lib/waku_light_push/index.ts:41](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_light_push/index.ts#L41)

## Properties

### libp2p

• **libp2p**: `Libp2p`

___

### pubSubTopic

• **pubSubTopic**: `string`

#### Defined in

[src/lib/waku_light_push/index.ts:39](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_light_push/index.ts#L39)

## Accessors

### peers

• `get` **peers**(): `Peer`[]

Returns known peers from the address book (`libp2p.peerStore`) that support
light push protocol. Waku may or  may not be currently connected to these peers.

#### Returns

`Peer`[]

#### Defined in

[src/lib/waku_light_push/index.ts:102](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_light_push/index.ts#L102)

___

### randomPeer

• `get` **randomPeer**(): `undefined` \| `Peer`

Returns a random peer that supports light push protocol from the address
book (`libp2p.peerStore`). Waku may or  may not be currently connected to
this peer.

#### Returns

`undefined` \| `Peer`

#### Defined in

[src/lib/waku_light_push/index.ts:111](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_light_push/index.ts#L111)

## Methods

### push

▸ **push**(`message`, `opts?`): `Promise`<``null`` \| [`PushResponse`](../modules.md#pushresponse)\>

#### Parameters

| Name | Type |
| :------ | :------ |
| `message` | [`WakuMessage`](WakuMessage.md) |
| `opts?` | `PushOptions` |

#### Returns

`Promise`<``null`` \| [`PushResponse`](../modules.md#pushresponse)\>

#### Defined in

[src/lib/waku_light_push/index.ts:49](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_light_push/index.ts#L49)
