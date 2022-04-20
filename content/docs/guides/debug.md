---
title: How to Debug your Waku dApp
date: 2022-01-31T00:00:00+01:00
weight: 20
---

# How to Debug your Waku dApp

## Enable Debug Logs

JS-Waku and its most relevant dependencies (libp2p) uses [debug](https://www.npmjs.com/package/debug) to handle logs.

### NodeJS

To enable debug logs when running js-waku with NodeJS, simply set the `DEBUG` environment variable.

To only enable js-waku debug logs:

```shell
export DEBUG=waku*
```

To enable js-waku and libp2p debug logs:

```sh
export DEBUG=waku*,libp2p*
```

To enable **all** debug logs:

```sh
export DEBUG=*
```

### Browser

To see the debug logs in your browser's console, you need to modify the local storage and add `debug` key.

Here are guides for some modern browsers:

- [Firefox](https://developer.mozilla.org/en-US/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage)
- [Chrome](https://developer.chrome.com/docs/devtools/storage/localstorage/)

| key     | value           | effect                               |
| ------- | --------------- | ------------------------------------ |
| `debug` | `waku*`         | enable js-waku debug logs            |
| `debug` | `waku*,libp2p*` | enable js-waku and libp2p debug logs |
| `debug` | `*`             | enable **all** debug logs            |

## Check Websocket Setup

Nwaku natively supports WebSocket (ws) and WebSocket Secure (wss).

These are currently the only transports supported to connect to the Waku network from a browser.

Modern browsers are restrictive with the usage of WebSocket:

- Within a secure context insecure subroutines are disallowed:
  On a `https://` webpage, only `wss` connections are allowed, not `ws`,
- Certificate validation checks are the same for `https` and `wss`:
  Certificate must not be expired,
  certificate needs to come from a CA recognize by the browser or system (no self-signed cert, no ip cert),
  domain name must match, etc,
- Subroutines errors are not displayed to the user:
  If a WebSocket connection fails, the user will not be informed, you need to check the browser's console.

Finally, these rules do not apply if the webpage is served locally (ie, on `localhost` or `127.0.0.1`).

If you have difficulties to connect to a remote node via `wss`:

**1. Check that the certificate is valid by opening the `wss` connection directly in the browser:**

If the multiaddr is `/dns4/nwakunode.com/tcp/1234/wss/p2p/16...` then open `https://nwakunode.com:1234` in a modern browser.
If you get a certificate error, then check why the browser returns this certificate error as this is the issue.

If you get a blank page, or any other error, go to step 2.

**2. Try to connect with [`websocat`](https://github.com/vi/websocat):**

Check if you can connect to the WebSocket port using `websocat`:

(assuming multiaddr is `/dns4/nwakunode.com/tcp/1234/wss/p2p/16...`)

```shell
websockat -v wss://nwakunode.com:1234
# ...
/multistream/1.0.0
```

If the last line is `/multistream/1.0.0` then it works! In this case, the issue might be somewhere in your code.
Do not hesitate to get support on the [Vac Discord](https://discord.gg/9DgykdmpZ6).

If you get an error, try with option `-k, --insecure    Accept invalid certificates and hostnames while connecting to TLS`:

```shell
websockat -vk wss://nwakunode.com:1234
# ...
/multistream/1.0.0
```

If it works, then you certificate being invalid is the issue.

If it does not work then indeed, your nwaku node does not accept WebSocket connections, go to 3 for a last check.

**3. Verify the WebSocket port is accessible:**

Use `telnet` (or any other networking tool) to check that the WebSocket port is indeed open and accessible:

(assuming multiaddr is `/dns4/nwakunode.com/tcp/1234/wss/p2p/16...`)

```shell
telnet nwakunode.com 1234
Trying 123.123.123.123...
Connected nwakunode.com.
Escape character is '^]'
```

(Press `CTRL-]` to escape).

If this works then indeed, there is an issue with `nwaku`, come get support on the [Vac Discord](https://discord.gg/9DgykdmpZ6) or open an [issue](https://github.com/status-im/nwaku/issues/new).

If this does not work then ensure the WebSocket port is open.
