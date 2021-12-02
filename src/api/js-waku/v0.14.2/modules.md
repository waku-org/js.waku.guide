[js-waku](README.md) / Exports

# js-waku

## Table of contents

### Namespaces

- [proto](modules/proto.md)
- [utils](modules/utils.md)

### Enumerations

- [PageDirection](enums/PageDirection.md)

### Classes

- [Waku](classes/Waku.md)
- [WakuLightPush](classes/WakuLightPush.md)
- [WakuMessage](classes/WakuMessage.md)
- [WakuRelay](classes/WakuRelay.md)
- [WakuStore](classes/WakuStore.md)

### Interfaces

- [PushResponse](interfaces/PushResponse.md)

### Variables

- [DefaultPubSubTopic](modules.md#defaultpubsubtopic)
- [LightPushCodec](modules.md#lightpushcodec)
- [PushResponse](modules.md#pushresponse)
- [RelayCodecs](modules.md#relaycodecs)
- [StoreCodec](modules.md#storecodec)

### Functions

- [generatePrivateKey](modules.md#generateprivatekey)
- [generateSymmetricKey](modules.md#generatesymmetrickey)
- [getBootstrapNodes](modules.md#getbootstrapnodes)
- [getPublicKey](modules.md#getpublickey)

## Variables

### DefaultPubSubTopic

• **DefaultPubSubTopic**: ``"/waku/2/default-waku/proto"``

DefaultPubSubTopic is the default gossipsub topic to use for Waku.

#### Defined in

[src/lib/waku.ts:37](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku.ts#L37)

___

### LightPushCodec

• **LightPushCodec**: ``"/vac/waku/lightpush/2.0.0-beta1"``

#### Defined in

[src/lib/waku_light_push/index.ts:15](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_light_push/index.ts#L15)

___

### PushResponse

• **PushResponse**: `Object`

#### Type declaration

| Name | Type |
| :------ | :------ |
| `decode` | (`input`: `Uint8Array` \| `Reader`, `length?`: `number`) => [`PushResponse`](modules.md#pushresponse) |
| `encode` | (`message`: [`PushResponse`](modules.md#pushresponse), `writer`: `Writer`) => `Writer` |
| `fromJSON` | (`object`: `any`) => [`PushResponse`](modules.md#pushresponse) |
| `fromPartial` | (`object`: { `info?`: `string` ; `isSuccess?`: `boolean`  }) => [`PushResponse`](modules.md#pushresponse) |
| `toJSON` | (`message`: [`PushResponse`](modules.md#pushresponse)) => `unknown` |

#### Defined in

[src/proto/waku/v2/light_push.ts:105](https://github.com/status-im/js-waku/blob/31325bb/src/proto/waku/v2/light_push.ts#L105)

___

### RelayCodecs

• **RelayCodecs**: `string`[]

RelayCodec is the libp2p identifier for the waku relay protocol

#### Defined in

[src/lib/waku_relay/constants.ts:7](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_relay/constants.ts#L7)

___

### StoreCodec

• **StoreCodec**: ``"/vac/waku/store/2.0.0-beta3"``

#### Defined in

[src/lib/waku_store/index.ts:19](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_store/index.ts#L19)

## Functions

### generatePrivateKey

▸ **generatePrivateKey**(): `Uint8Array`

Generate a new private key to be used for asymmetric encryption.

Use [getPublicKey](modules.md#getpublickey) to get the corresponding Public Key.

#### Returns

`Uint8Array`

#### Defined in

[src/lib/waku_message/version_1.ts:181](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/version_1.ts#L181)

___

### generateSymmetricKey

▸ **generateSymmetricKey**(): `Uint8Array`

Generate a new symmetric key to be used for symmetric encryption.

#### Returns

`Uint8Array`

#### Defined in

[src/lib/waku_message/version_1.ts:188](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/version_1.ts#L188)

___

### getBootstrapNodes

▸ **getBootstrapNodes**(`path?`, `url?`, `wantedNumber?`): `Promise`<`string`[]\>

GET list of nodes from remote HTTP host.

Default behaviour is to return nodes hosted by Status.

**`throws`** If the remote host is unreachable or the response cannot be parsed
according to the passed _path_.

#### Parameters

| Name | Type | Default value | Description |
| :------ | :------ | :------ | :------ |
| `path` | `string`[] | `undefined` | The property path to access the node list. The result should be a string, a string array or an object. If the result is an object then the values of the objects are used as multiaddresses. For example, if the GET request returns `{ foo: { bar: [address1, address2] } }` then `path` should be `[ "foo", "bar" ]`. |
| `url` | `string` | `'https://fleets.status.im/'` | Remote host containing bootstrap peers in JSON format. |
| `wantedNumber` | `number` | `DefaultWantedNumber` | The number of connections desired. Defaults to [DefaultWantedNumber]. |

#### Returns

`Promise`<`string`[]\>

An array of multiaddresses.

#### Defined in

[src/lib/discovery.ts:26](https://github.com/status-im/js-waku/blob/31325bb/src/lib/discovery.ts#L26)

___

### getPublicKey

▸ **getPublicKey**(`privateKey`): `Uint8Array`

Return the public key for the given private key, to be used for asymmetric
encryption.

#### Parameters

| Name | Type |
| :------ | :------ |
| `privateKey` | `Buffer` \| `Uint8Array` |

#### Returns

`Uint8Array`

#### Defined in

[src/lib/waku_message/version_1.ts:196](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/version_1.ts#L196)
