---
title: Introduction
date: 2021-12-09T14:00:00+01:00
weight: 10
---

# JS-Waku Docs

{{< hint danger >}}
The js-waku library has recently been refactored to achieve a number of production readiness goals.
Hence, the code snippets present in this documentation are outdated.

Until the doc is updated, the best way to learn how to use js-waku is to check out the [examples](https://github.com/waku-org/js-waku-examples) repository.

Learn more about the refactoring [here](https://github.com/waku-org/js-waku/issues/802).
{{< /hint >}}

Waku is a family of protocols designed to provide censorship-resistant, privacy preserving, surveillance prone and portable communication.

The Waku software suite enables you to add communication features to your dApp in a decentralized manner,
ensuring to your users that they will not be censored or de-platformed.

Waku can be used for chat purposes and for many machine-to-machine use cases.
You can learn more about Waku at [waku.org](https://waku.org).

JS-Waku is the TypeScript implementation of the Waku protocol,
built for browser environment.

The [quick start](/docs/quick_start/) presents an easy way to send and receive messages using js-waku.
The [FAQ](/docs/faq/) lists frequently asked questions.

If you prefer video content, check out the [presentations](/docs/presentations).

If you are looking for inspiration, check out the [use cases](/docs/use_cases) Waku can enable.

The [guides](/docs/guides) explain specific js-waku features
and how it can be used with popular web frameworks.

The [js-waku-examples](https://github.com/waku-org/js-waku-examples) repository also holds a number of examples.
They are working Proof-of-Concepts that demonstrate how to use js-waku.
Check out the [example list](/docs/examples/) to see what usage each example demonstrates.

The examples are also deployed:

- [web-chat](https://examples.waku.org/web-chat): A simple public chat ([docs](/docs/examples/#web-chat-app)).
- [eth-pm](https://examples.waku.org/eth-pm): End-to-end encrypted private messages
  ([docs](/docs/examples/#ethereum-private-message-web-app)).
- [rln-js](https://examples.waku.org/rln-js): Demonstration of [RLN](https://rfc.vac.dev/spec/32/),
  an economic spam protection protocol that rate limit using zero-knowledge for privacy preserving purposes.

If you want to play with examples, please, use one of the following commands to easily bootstrap an example:

- `yarn create @waku/app <project-dir>`
- `npx @waku/create-app <project-dir>`

Finally, if you want to learn how Waku works under the hoods, check the specs at [rfc.vac.dev](https://rfc.vac.dev/).

## Bugs, Questions & Support

If you encounter any bug or would like to propose new features, feel free to [open an issue](https://github.com/waku-org/js-waku/issues/new/).

For general discussion, get help or latest news,
join **#js-waku** on [Vac Discord](https://discord.gg/Nrac59MfSX) or the [Waku Telegram Group](https://t.me/waku_org).
