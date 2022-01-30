---
title: How to Debug your Waku dApp
date: 2022-01-31T00:00:00+01:00
weight: 9
---

# How to Debug your Waku dApp

JS-Waku and its most relevant dependencies (libp2p) uses [debug](https://www.npmjs.com/package/debug) to handle logs.

## NodeJS

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

## Browser

To see the debug logs in your browser's console, you need to modify the local storage and add `debug` key.

Here are guides for some modern browsers:

- [Firefox](https://developer.mozilla.org/en-US/docs/Tools/Storage_Inspector/Local_Storage_Session_Storage)
- [Chrome](https://developer.chrome.com/docs/devtools/storage/localstorage/)


| key     | value           | effect                               |
|---------|-----------------|--------------------------------------|
| `debug` | `waku*`         | enable js-waku debug logs            |  
| `debug` | `waku*,libp2p*` | enable js-waku and libp2p debug logs |
| `debug` | `*`             | enable **all** debug logs            |
