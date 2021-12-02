# Cryptographic Libraries

A note on the cryptographic libraries used as it is a not a straightforward affair.


## Asymmetric encryption

Uses [ecies-geth](https://github.com/cyrildever/ecies-geth/)
which in turns uses [SubtleCrypto](https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto) Web API (browser),
[secp256k1](https://www.npmjs.com/package/secp256k1) (native binding for node)
or [elliptic](https://www.npmjs.com/package/elliptic) (pure JS if none of the other libraries are available).


## Symmetric encryption

Uses [SubtleCrypto](https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto) Web API (browser)
or [NodeJS' crypto](https://nodejs.org/api/crypto.html) module.
