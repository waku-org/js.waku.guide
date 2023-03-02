---
title: Send and Receive Messages Using Waku Relay With Angular v13
date: 2022-02-15T09:00:00+01:00
weight: 90
---

# Send and Receive Messages Using Waku Relay With Angular v13

It is easy to use Waku Connect with Angular v13.

In this guide, we will demonstrate how your Angular dApp can use Waku Relay
to send and receive messages.

Before starting, you need to choose a _Content Topic_ for your dApp.
Check out the [how to choose a content topic guide](/docs/guides/01_choose_content_topic/) to learn more about content topics.

For this guide, we are using a single content topic: `/relay-angular-chat/1/chat/proto`.

## Setup

Create a new Angular app:

```shell
npm install -g @angular/cli
ng new relay-angular-chat
cd relay-angular-chat
```

### `BigInt`

Some of js-waku's dependencies use [`BigInt`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt)
that is [only supported by modern browsers](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/BigInt#browser_compatibility).

To ensure that Angular properly transpiles your webapp code, add the following configuration to the `package.json` file:

```json
{
  "browserslist": {
    "production": [
      ">0.2%",
      "not ie <= 99",
      "not android <= 4.4.4",
      "not dead",
      "not op_mini all"
    ]
  }
}
```

### Polyfills

A number of Web3 and libp2p dependencies need polyfills.
These must be explicitly declared when using webpack 5.

The latest `Angular` version (v13) uses webpack 5.

We will describe below a method to configure polyfills when using `Angular v13 / webpack v5`.
This may not be necessary if you use webpack 4.

Start by installing the polyfill libraries:

```shell
yarn add assert buffer crypto-browserify process stream-browserify
```

Then add the following code to `src/polyfills.ts`:

```js
import * as process from 'process';
(window as any).process = process;
(window as any).global = window;
global.Buffer = global.Buffer || require('buffer').Buffer;
```

Now tell Angular where to find these libraries by adding the following to `tsconfig.json`
under `"compilerOptions"`:

```json
{
  "paths": {
    "assert": ["node_modules/assert"],
    "buffer": ["node_modules/buffer"],
    "crypto": ["node_modules/crypto-browserify"],
    "stream": ["node_modules/stream-browserify"]
  }
}
```

Now under `"angularCompilerOptions"`, add:

```json
"allowSyntheticDefaultImports": true
```

Finally, set the `"target"` to be `"es2020"` due to the aforementioned `BigInt` usage.

### Module loading warnings

There will be some warnings due to module loading.
We can fix them by setting the `"allowedCommonJsDependencies"` key under
`architect -> build -> options` with the following:

```json
{
  "allowedCommonJsDependencies": [
    "libp2p-gossipsub/src/utils",
    "rlp",
    "multiaddr/src/convert",
    "varint",
    "multihashes",
    "@chainsafe/libp2p-noise/dist/src/noise",
    "debug",
    "libp2p",
    "libp2p-bootstrap",
    "libp2p-crypto",
    "libp2p-websockets",
    "libp2p-websockets/src/filters",
    "libp2p/src/ping",
    "multiaddr",
    "peer-id",
    "buffer",
    "crypto",
    "ecies-geth",
    "secp256k1",
    "libp2p-gossipsub",
    "it-concat",
    "protons"
  ]
}
```

### Types

There are some type definitions we need to install and some that we don't have.

```shell
yarn add @types/bl protons
```

Create a new folder under `src` named `@types` with the following structure:

```shell
src/@types
├── protons
│   └── types.d.ts
└── time-cache
    └── types.d.ts
```

In the `protons/types.d.ts` file add:

```js
declare module 'protons';
```

In the `time-cache/types.d.ts` file add:

```js
declare module "time-cache" {

  interface TimeCacheInterface {
    put(key: string, value: any, validity: number): void;
    get(key: string): any;
    has(key: string): boolean;
  }

  type TimeCache = TimeCacheInterface;

  function TimeCache(options: object): TimeCache;

  export = TimeCache;
}
```

### js-waku

Then, install [js-waku](https://npmjs.com/package/js-waku):

```shell
yarn add js-waku
```

Start the dev server and open the dApp in your browser:

```shell
yarn run start
```

## Create Waku Instance

In order to interact with the Waku network, you first need a Waku instance.
We're going to wrap the `js-waku` library in a Service so we can inject it to different components when needed.

Generate the Waku service:

```shell
ng generate service waku
```

Go to `waku.service.ts` and add the following imports:

```js
import { Waku } from "js-waku";
import { ReplaySubject } from "rxjs";
```

replace the `WakuService` class with the following:

```js
export class WakuService {

  // Create Subject Observable to 'store' the Waku instance
  private wakuSubject = new Subject<Waku>();
  public waku = this.wakuSubject.asObservable();

  // Create BehaviorSubject Observable to 'store' the Waku status
  private wakuStatusSubject = new BehaviorSubject('');
  public wakuStatus = this.wakuStatusSubject.asObservable();

  constructor() { }

  init() {
    // Connect node
    Waku.create({ bootstrap: { default: true } }).then(waku => {
      // Update Observable values
      this.wakuSubject.next(waku);
      this.wakuStatusSubject.next('Connecting...');

      waku.waitForRemotePeer().then(() => {
        // Update Observable value
        this.wakuStatusSubject.next('Connected');
      });
    });
  }
}
```

When using the `bootstrap` option, it may take some time to connect to other peers.
That's why we use the `waku.waitForRemotePeer` function to ensure that there are relay peers available to send and receive messages.

Now we can inject the `WakuService` in to the `AppComponent` class to initialize the node and
subscribe to any status changes.

Firstly, import the `WakuService`:

```js
import { WakuService } from "./waku.service";
```

Then update the `AppComponent` class with the following:

```js
export class AppComponent {

  title: string = 'relay-angular-chat';
  wakuStatus!: string;

  // Inject the service
  constructor(private wakuService: WakuService) {}

  ngOnInit(): void {
    // Call the `init` function on the service
    this.wakuService.init();
    // Subscribe to the `wakuStatus` Observable and update the property when it changes
    this.wakuService.wakuStatus.subscribe(wakuStatus => {
      this.wakuStatus = wakuStatus;
    });
  }
}
```

Add the following HTML to the `app.component.html` to show the title and render the connection status:

```html
<h1>{{title}}</h1>
<p>Waku node's status: {{ wakuStatus }}</p>
```

## Messages

Now we need to create a component to send, receive and render the messages.

```shell
ng generate component messages
```

You might need to add this to `NgModule` for Angular to pick up the new component.
Import and add `MessagesComponent` to the `declarations` array in `app.module.ts`.

We're going to need the `WakuService` again but also the `Waku` and `WakuMessage` classes from `js-waku`.
We already installed [protons](https://www.npmjs.com/package/protons)
and we're going to use that here so we'll need to import it.

```js
import { WakuService } from "../waku.service";
import { Waku, WakuMessage } from "js-waku";
import protons from "protons";
```

Let's use `protons` to define the Protobuf message format with two fields:
`timestamp` and `text`:

```js
const proto = protons(`
message SimpleChatMessage {
  uint64 timestamp = 1;
  string text = 2;
}
`);
```

Let's also define a message `interface`:

```js
interface MessageInterface {
  timestamp: Date;
  text: string;
}
```

## Send Messages

In order to send a message, we need to define a few things.

The `contentTopic` is the topic we want subscribe to and the `payload` is the message.
We've also defined a `timestamp` so let's create that.

The `messageCount` property is just to distinguish between messages.

We also need our `waku` instance and `wakuStatus` property.
We will subscribe to the `waku` and `wakuStatus` Observables from the `WakuService` to get them.

```js
export class MessagesComponent {

  contentTopic: string = `/relay-angular-chat/1/chat/proto`;
  messageCount: number = 0;
  waku!: Waku;

  // ...

  // Inject the `WakuService`
  constructor(private wakuService: WakuService) { }

  ngOnInit(): void {
    // Subscribe to the `wakuStatus` Observable and update the property when it changes
    this.wakuService.wakuStatus.subscribe(wakuStatus => {
      this.wakuStatus = wakuStatus;
    });

    // Subscribe to the `waku` Observable and update the property when it changes
    this.wakuService.waku.subscribe(waku => {
      this.waku = waku;
    });
  }

  sendMessage(): void {
    const time = new Date().getTime();

    const payload = proto.SimpleChatMessage.encode({
      timestamp: time,
      text: `Here is a message #${this.messageCount}`,
    });

    WakuMessage.fromBytes(payload, this.contentTopic).then(wakuMessage => {
      this.waku.relay.send(wakuMessage).then(() => {
        console.log(`Message #${this.messageCount} sent`);
        this.messageCount += 1;
      });
    });
  }
}
```

Then, add a button to the `messages.component.html` file to wire it up to the `sendMessage()` function.
It will also disable the button until the node is connected.

```
<button (click)="sendMessage()" [disabled]="wakuStatus !== 'Connected'">Send Message</button>
```

## Receive Messages

To process incoming messages, you need to register an observer on Waku Relay.
First, you need to define the observer function which decodes the message
and pushes it in to the `messages` array.

Again, in the `messages.component.ts`:

```js
export class MessagesComponent {
  // ...
  // Store the messages in an array
  messages: MessageInterface[] = [];
  // ...

  processIncomingMessages = (wakuMessage: WakuMessage) => {
    if (!wakuMessage.payload) return;

    const { timestamp, text } = proto.SimpleChatMessage.decode(
      wakuMessage.payload
    );

    const time = new Date();
    time.setTime(timestamp);
    const message = { text, timestamp: time };

    this.messages.push(message);
  };
}
```

We'll also need to delete the observer when the component gets destroyed
to avoid memory leaks:

```js
ngOnDestroy(): void {
  this.waku.relay.deleteObserver(this.processIncomingMessages, [this.contentTopic]);
}
```

Angular won't delete the observer when the page reloads so we'll have to hook that up ourselves.
Add the following to the `ngOnInit()` function:

```js
window.onbeforeunload = () => this.ngOnDestroy();
```

## Display Messages

Congratulations! The Waku work is now done.
Your dApp is able to send and receive messages using Waku.
For the sake of completeness, let's display received messages on the page.

We've already added the `messages` array and pushed the incoming message to it.
So all we have to do now is render them to the page.

In the `messages.component.html`, add the following under the `button`:

```html
<h2>Messages</h2>
<ul class="messages">
  <li *ngFor="let message of messages">
    <span>{{ message.timestamp }} {{ message.text }}</span>
  </li>
</ul>
```

And Voilà! You should now be able to send and receive messages.
Try it out by opening the app from different browsers!

You can see the complete code in the [Relay Angular Chat Example App](https://github.com/status-im/js-waku/tree/main/examples/relay-angular-chat).
