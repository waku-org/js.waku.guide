[js-waku](../README.md) / [Exports](../modules.md) / WakuMessage

# Class: WakuMessage

## Table of contents

### Constructors

- [constructor](WakuMessage.md#constructor)

### Properties

- [proto](WakuMessage.md#proto)

### Accessors

- [contentTopic](WakuMessage.md#contenttopic)
- [payload](WakuMessage.md#payload)
- [payloadAsUtf8](WakuMessage.md#payloadasutf8)
- [signature](WakuMessage.md#signature)
- [signaturePublicKey](WakuMessage.md#signaturepublickey)
- [timestamp](WakuMessage.md#timestamp)
- [version](WakuMessage.md#version)

### Methods

- [encode](WakuMessage.md#encode)
- [decode](WakuMessage.md#decode)
- [decodeProto](WakuMessage.md#decodeproto)
- [fromBytes](WakuMessage.md#frombytes)
- [fromUtf8String](WakuMessage.md#fromutf8string)

## Constructors

### constructor

• `Private` **new WakuMessage**(`proto`, `_signaturePublicKey?`, `_signature?`)

#### Parameters

| Name | Type |
| :------ | :------ |
| `proto` | [`WakuMessage`](../modules/proto.md#wakumessage) |
| `_signaturePublicKey?` | `Uint8Array` |
| `_signature?` | `Uint8Array` |

#### Defined in

[src/lib/waku_message/index.ts:40](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L40)

## Properties

### proto

• **proto**: [`WakuMessage`](../modules/proto.md#wakumessage)

## Accessors

### contentTopic

• `get` **contentTopic**(): `undefined` \| `string`

#### Returns

`undefined` \| `string`

#### Defined in

[src/lib/waku_message/index.ts:215](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L215)

___

### payload

• `get` **payload**(): `undefined` \| `Uint8Array`

#### Returns

`undefined` \| `Uint8Array`

#### Defined in

[src/lib/waku_message/index.ts:211](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L211)

___

### payloadAsUtf8

• `get` **payloadAsUtf8**(): `string`

#### Returns

`string`

#### Defined in

[src/lib/waku_message/index.ts:203](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L203)

___

### signature

• `get` **signature**(): `undefined` \| `Uint8Array`

The signature of the message.

MAY be present if the message is version 1.

#### Returns

`undefined` \| `Uint8Array`

#### Defined in

[src/lib/waku_message/index.ts:244](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L244)

___

### signaturePublicKey

• `get` **signaturePublicKey**(): `undefined` \| `Uint8Array`

The public key used to sign the message.

MAY be present if the message is version 1.

#### Returns

`undefined` \| `Uint8Array`

#### Defined in

[src/lib/waku_message/index.ts:235](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L235)

___

### timestamp

• `get` **timestamp**(): `undefined` \| `Date`

#### Returns

`undefined` \| `Date`

#### Defined in

[src/lib/waku_message/index.ts:223](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L223)

___

### version

• `get` **version**(): `undefined` \| `number`

#### Returns

`undefined` \| `number`

#### Defined in

[src/lib/waku_message/index.ts:219](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L219)

## Methods

### encode

▸ **encode**(): `Uint8Array`

#### Returns

`Uint8Array`

#### Defined in

[src/lib/waku_message/index.ts:199](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L199)

___

### decode

▸ `Static` **decode**(`bytes`, `decryptionKeys?`): `Promise`<`undefined` \| [`WakuMessage`](WakuMessage.md)\>

Decode a byte array into Waku Message.

**`params`** bytes The message encoded using protobuf as defined in [14/WAKU2-MESSAGE](https://rfc.vac.dev/spec/14/).

**`params`** decryptionKeys If the payload is encrypted (version = 1), then the
keys are used to attempt decryption of the message. The passed key can either
be asymmetric private keys or symmetric keys, both method are tried for each
key until the message is decrypted or combinations are ran out.

#### Parameters

| Name | Type |
| :------ | :------ |
| `bytes` | `Uint8Array` |
| `decryptionKeys?` | `Uint8Array`[] |

#### Returns

`Promise`<`undefined` \| [`WakuMessage`](WakuMessage.md)\>

#### Defined in

[src/lib/waku_message/index.ts:121](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L121)

___

### decodeProto

▸ `Static` **decodeProto**(`protoBuf`, `decryptionKeys?`): `Promise`<`undefined` \| [`WakuMessage`](WakuMessage.md)\>

Decode and decrypt Waku Message Protobuf Object into Waku Message.

**`params`** protoBuf The message to decode and decrypt.

**`params`** decryptionKeys If the payload is encrypted (version = 1), then the
keys are used to attempt decryption of the message. The passed key can either
be asymmetric private keys or symmetric keys, both method are tried for each
key until the message is decrypted or combinations are ran out.

#### Parameters

| Name | Type |
| :------ | :------ |
| `protoBuf` | [`WakuMessage`](../modules/proto.md#wakumessage) |
| `decryptionKeys?` | `Uint8Array`[] |

#### Returns

`Promise`<`undefined` \| [`WakuMessage`](WakuMessage.md)\>

#### Defined in

[src/lib/waku_message/index.ts:139](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L139)

___

### fromBytes

▸ `Static` **fromBytes**(`payload`, `contentTopic`, `opts?`): `Promise`<[`WakuMessage`](WakuMessage.md)\>

Create a Waku Message with the given payload.

By default, the payload is kept clear (version 0).
If `opts.encPublicKey` is passed, the payload is encrypted using
asymmetric encryption (version 1).

If `opts.sigPrivKey` is passed and version 1 is used, the payload is signed
before encryption.

**`throws`** if both `opts.encPublicKey` and `opt.symKey` are passed

#### Parameters

| Name | Type |
| :------ | :------ |
| `payload` | `Uint8Array` |
| `contentTopic` | `string` |
| `opts?` | `Options` |

#### Returns

`Promise`<[`WakuMessage`](WakuMessage.md)\>

#### Defined in

[src/lib/waku_message/index.ts:70](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L70)

___

### fromUtf8String

▸ `Static` **fromUtf8String**(`utf8`, `contentTopic`, `opts?`): `Promise`<[`WakuMessage`](WakuMessage.md)\>

Create Message with a utf-8 string as payload.

#### Parameters

| Name | Type |
| :------ | :------ |
| `utf8` | `string` |
| `contentTopic` | `string` |
| `opts?` | `Options` |

#### Returns

`Promise`<[`WakuMessage`](WakuMessage.md)\>

#### Defined in

[src/lib/waku_message/index.ts:49](https://github.com/status-im/js-waku/blob/31325bb/src/lib/waku_message/index.ts#L49)
