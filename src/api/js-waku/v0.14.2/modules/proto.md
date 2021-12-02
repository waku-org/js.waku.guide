[js-waku](../README.md) / [Exports](../modules.md) / proto

# Namespace: proto

## Table of contents

### Enumerations

- [PagingInfo\_Direction](../enums/proto.PagingInfo_Direction.md)

### Interfaces

- [ContentFilter](../interfaces/proto.ContentFilter.md)
- [HistoryQuery](../interfaces/proto.HistoryQuery.md)
- [HistoryRPC](../interfaces/proto.HistoryRPC.md)
- [HistoryResponse](../interfaces/proto.HistoryResponse.md)
- [Index](../interfaces/proto.Index.md)
- [PagingInfo](../interfaces/proto.PagingInfo.md)
- [WakuMessage](../interfaces/proto.WakuMessage.md)

### Variables

- [ContentFilter](proto.md#contentfilter)
- [HistoryQuery](proto.md#historyquery)
- [HistoryRPC](proto.md#historyrpc)
- [HistoryResponse](proto.md#historyresponse)
- [Index](proto.md#index)
- [PagingInfo](proto.md#paginginfo)
- [WakuMessage](proto.md#wakumessage)

## Variables

### ContentFilter

• **ContentFilter**: `Object`

#### Type declaration

| Name | Type |
| :------ | :------ |
| `decode` | (`input`: `Uint8Array` \| `Reader`, `length?`: `number`) => [`ContentFilter`](proto.md#contentfilter) |
| `encode` | (`message`: [`ContentFilter`](proto.md#contentfilter), `writer`: `Writer`) => `Writer` |
| `fromJSON` | (`object`: `any`) => [`ContentFilter`](proto.md#contentfilter) |
| `fromPartial` | (`object`: { `contentTopic?`: `string`  }) => [`ContentFilter`](proto.md#contentfilter) |
| `toJSON` | (`message`: [`ContentFilter`](proto.md#contentfilter)) => `unknown` |

#### Defined in

[src/proto/waku/v2/store.ts:305](https://github.com/status-im/js-waku/blob/31325bb/src/proto/waku/v2/store.ts#L305)

___

### HistoryQuery

• **HistoryQuery**: `Object`

#### Type declaration

| Name | Type |
| :------ | :------ |
| `decode` | (`input`: `Uint8Array` \| `Reader`, `length?`: `number`) => [`HistoryQuery`](proto.md#historyquery) |
| `encode` | (`message`: [`HistoryQuery`](proto.md#historyquery), `writer`: `Writer`) => `Writer` |
| `fromJSON` | (`object`: `any`) => [`HistoryQuery`](proto.md#historyquery) |
| `fromPartial` | (`object`: { `contentFilters?`: { contentTopic?: string \| undefined; }[] ; `endTime?`: `number` ; `pagingInfo?`: { pageSize?: number \| undefined; cursor?: { digest?: Uint8Array \| undefined; receivedTime?: number \| undefined; senderTime?: number \| undefined; } \| undefined; direction?: PagingInfo\_Direction \| undefined; } ; `pubSubTopic?`: `string` ; `startTime?`: `number`  }) => [`HistoryQuery`](proto.md#historyquery) |
| `toJSON` | (`message`: [`HistoryQuery`](proto.md#historyquery)) => `unknown` |

#### Defined in

[src/proto/waku/v2/store.ts:364](https://github.com/status-im/js-waku/blob/31325bb/src/proto/waku/v2/store.ts#L364)

___

### HistoryRPC

• **HistoryRPC**: `Object`

#### Type declaration

| Name | Type |
| :------ | :------ |
| `decode` | (`input`: `Uint8Array` \| `Reader`, `length?`: `number`) => [`HistoryRPC`](proto.md#historyrpc) |
| `encode` | (`message`: [`HistoryRPC`](proto.md#historyrpc), `writer`: `Writer`) => `Writer` |
| `fromJSON` | (`object`: `any`) => [`HistoryRPC`](proto.md#historyrpc) |
| `fromPartial` | (`object`: { `query?`: { pubSubTopic?: string \| undefined; contentFilters?: { contentTopic?: string \| undefined; }[] \| undefined; pagingInfo?: { pageSize?: number \| undefined; cursor?: { digest?: Uint8Array \| undefined; receivedTime?: number \| undefined; senderTime?: number \| undefined; } \| undefined; direction?: PagingInfo\_Direction \| un... ; `requestId?`: `string` ; `response?`: { messages?: { payload?: Uint8Array \| undefined; contentTopic?: string \| undefined; version?: number \| undefined; timestamp?: number \| undefined; }[] \| undefined; pagingInfo?: { ...; } \| undefined; error?: HistoryResponse\_Error \| undefined; }  }) => [`HistoryRPC`](proto.md#historyrpc) |
| `toJSON` | (`message`: [`HistoryRPC`](proto.md#historyrpc)) => `unknown` |

#### Defined in

[src/proto/waku/v2/store.ts:610](https://github.com/status-im/js-waku/blob/31325bb/src/proto/waku/v2/store.ts#L610)

___

### HistoryResponse

• **HistoryResponse**: `Object`

#### Type declaration

| Name | Type |
| :------ | :------ |
| `decode` | (`input`: `Uint8Array` \| `Reader`, `length?`: `number`) => [`HistoryResponse`](proto.md#historyresponse) |
| `encode` | (`message`: [`HistoryResponse`](proto.md#historyresponse), `writer`: `Writer`) => `Writer` |
| `fromJSON` | (`object`: `any`) => [`HistoryResponse`](proto.md#historyresponse) |
| `fromPartial` | (`object`: { `error?`: `HistoryResponse_Error` ; `messages?`: { payload?: Uint8Array \| undefined; contentTopic?: string \| undefined; version?: number \| undefined; timestamp?: number \| undefined; }[] ; `pagingInfo?`: { pageSize?: number \| undefined; cursor?: { digest?: Uint8Array \| undefined; receivedTime?: number \| undefined; senderTime?: number \| undefined; } \| undefined; direction?: PagingInfo\_Direction \| undefined; }  }) => [`HistoryResponse`](proto.md#historyresponse) |
| `toJSON` | (`message`: [`HistoryResponse`](proto.md#historyresponse)) => `unknown` |

#### Defined in

[src/proto/waku/v2/store.ts:505](https://github.com/status-im/js-waku/blob/31325bb/src/proto/waku/v2/store.ts#L505)

___

### Index

• **Index**: `Object`

#### Type declaration

| Name | Type |
| :------ | :------ |
| `decode` | (`input`: `Uint8Array` \| `Reader`, `length?`: `number`) => [`Index`](proto.md#index) |
| `encode` | (`message`: [`Index`](proto.md#index), `writer`: `Writer`) => `Writer` |
| `fromJSON` | (`object`: `any`) => [`Index`](proto.md#index) |
| `fromPartial` | (`object`: { `digest?`: `Uint8Array` ; `receivedTime?`: `number` ; `senderTime?`: `number`  }) => [`Index`](proto.md#index) |
| `toJSON` | (`message`: [`Index`](proto.md#index)) => `unknown` |

#### Defined in

[src/proto/waku/v2/store.ts:118](https://github.com/status-im/js-waku/blob/31325bb/src/proto/waku/v2/store.ts#L118)

___

### PagingInfo

• **PagingInfo**: `Object`

#### Type declaration

| Name | Type |
| :------ | :------ |
| `decode` | (`input`: `Uint8Array` \| `Reader`, `length?`: `number`) => [`PagingInfo`](proto.md#paginginfo) |
| `encode` | (`message`: [`PagingInfo`](proto.md#paginginfo), `writer`: `Writer`) => `Writer` |
| `fromJSON` | (`object`: `any`) => [`PagingInfo`](proto.md#paginginfo) |
| `fromPartial` | (`object`: { `cursor?`: { digest?: Uint8Array \| undefined; receivedTime?: number \| undefined; senderTime?: number \| undefined; } ; `direction?`: [`PagingInfo_Direction`](../enums/proto.PagingInfo_Direction.md) ; `pageSize?`: `number`  }) => [`PagingInfo`](proto.md#paginginfo) |
| `toJSON` | (`message`: [`PagingInfo`](proto.md#paginginfo)) => `unknown` |

#### Defined in

[src/proto/waku/v2/store.ts:211](https://github.com/status-im/js-waku/blob/31325bb/src/proto/waku/v2/store.ts#L211)

___

### WakuMessage

• **WakuMessage**: `Object`

#### Type declaration

| Name | Type |
| :------ | :------ |
| `decode` | (`input`: `Uint8Array` \| `Reader`, `length?`: `number`) => [`WakuMessage`](proto.md#wakumessage) |
| `encode` | (`message`: [`WakuMessage`](proto.md#wakumessage), `writer`: `Writer`) => `Writer` |
| `fromJSON` | (`object`: `any`) => [`WakuMessage`](proto.md#wakumessage) |
| `fromPartial` | (`object`: { `contentTopic?`: `string` ; `payload?`: `Uint8Array` ; `timestamp?`: `number` ; `version?`: `number`  }) => [`WakuMessage`](proto.md#wakumessage) |
| `toJSON` | (`message`: [`WakuMessage`](proto.md#wakumessage)) => `unknown` |

#### Defined in

[src/proto/waku/v2/message.ts:16](https://github.com/status-im/js-waku/blob/31325bb/src/proto/waku/v2/message.ts#L16)
