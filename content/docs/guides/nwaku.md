---
title: Nwaku Service Node
date: 2022-02-17T00:00:00+01:00
weight: 10
---

# Nwaku Service Node

JS-Waku nodes join the Waku network by connecting to service nodes using secure websocket.

[Nwaku (prev. nim-waku)](https://github.com/status-im/nim-waku/tree/master/waku/v2)
is the reference implementation of the Waku v2 protocol and can be used as a service node.

When using [`{ bootstrap: { default: true } }`](https://js-waku.wakuconnect.dev/interfaces/discovery.BootstrapOptions.html#default),
the js-waku node connects to a fleet of nwaku nodes operated by Status.

It is also possible to deploy your own nwaku node by following [these instructions](https://github.com/status-im/nim-waku/tree/master/waku/v2#enabling-websocket).
Be sure to setup your nwaku node with a valid SSL certificate or js-waku nodes may fail silently to connect to it.

{{< hint info >}}
We are making it easier for operators to run their own nodes,
this is effort is tracked with [status-im/nim-waku#828](https://github.com/status-im/nim-waku/issues/828).
{{< /hint >}}

You may wish to connect your nwaku node to the rest of the fleet.
This can be done with the `--staticnode` or `--dns-discovery-url`.
For example:

```sh
`wakunode2 \
  --dns-discovery=true \
  --dns-discovery-url=enrtree://ANTL4SLG2COUILKAPE7EF2BYNL2SHSHVCHLRD5J7ZJLN5R3PRJD2Y@prod.waku.nodes.status.im
```

You can then use [`bootstrap.peers`](https://js-waku.wakuconnect.dev/interfaces/discovery.BootstrapOptions.html#peers)
to pass the multiaddr of your node.

For example (replace the multiaddr with your node's).

```js
import { Waku } from "js-waku";

const waku = await Waku.create({
  bootstrap: {
    peers: [
      "/dns4/node-01.ac-cn-hongkong-c.wakuv2.test.statusim.net/tcp/443/wss/p2p/16Uiu2HAkvWiyFsgRhuJEb9JfjYxEkoHLgnUQmr1N5mKWnYjxYRVm",
    ],
  },
});
```
