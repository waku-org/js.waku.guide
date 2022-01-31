---
title: Connect to the Ethereum Wallet useDapp
date: 2022-01-03T11:00:00+1100
weight: 3
---

# Connect to the Ethereum Wallet

{{< hint info >}}
This section may be skipped if you are adding the poll feature to an existing dApp
that already connects to the user's wallet.
This section can be used instead of previous step.
It demonstrates how to use `@useDapp` for wallet connection.
{{< /hint >}}

In this guide, we use [useDApp](https://usedapp.io/) to access the blockchain.

```shell
yarn add @usedapp/core@0.4.7
```

{{< hint warning >}}
`@usedapp/core` must be frozen to version `0.4.7` due to incompatibility between minor versions of `ethers`.

Waku Connect Vote & Poll SDK will be upgraded to the latest version of `@usedapp/core` and `ethers` once `ethereum-waffle`
is released with the [latest version of `ethers`](https://github.com/EthWorks/Waffle/pull/603).
{{< /hint >}}

Delete the template `App` component:

```shell
rm -f App.tsx App.css App.test.tsx
```

## Top bar

Use `TopBar` component to display wallet information.
For that, create a `PollPage` component that includes the top bar and will include the poll elements.
The component uses `ethers` to connect to the user's wallet:

```tsx
export function PollPage() {
  const { account, library, activateBrowserWallet, deactivate } = useEthers();
  const [signer, setSigner] = useState<undefined | JsonRpcSigner>(undefined);

  useEffect(() => {
    if (account) {
      setSigner(library?.getSigner());
    } else {
      // Deactivate signer if signed out
      setSigner(undefined);
    }
  }, [account]);

  return (
    <div>
      <TopBar
        logo={""}
        logoWidth={84}
        title={"Poll dApp"}
        theme={orangeTheme}
        activate={activateBrowserWallet}
        account={account}
        deactivate={deactivate}
      />
    </div>
  );
}
```

## Page

### UseDApp

Create a `config` variable that contains the Ethereum network parameters:

```tsx
import {ChainId, DAppProvider, useEthers} from '@usedapp/core';

const config = {
    readOnlyChainId: ChainId.Mainnet,
    readOnlyUrls: {
        [ChainId.Mainnet]: 'https://mainnet.infura.io/v3/your-infura-token',
    },
    multicallAddresses: {
        1: '0xeefba1e63905ef1d7acba5a8513c70307c1ce441',
        3: '0x53c43764255c17bd724f74c4ef150724ac50a3ed',
    },
    notifications: {
        checkInterval: 500,
        expirationPeriod: 50000,
    },
}
```

Replace `your-infura-token` with your [Infura API token](https://infura.io/docs/ethereum).

### Styled-components

[`styled-components`](https://styled-components.com/) is used for easy styling.
Create a `Wrapper` variable to use in the page component:

```tsx
import styled from "styled-components";

const Wrapper = styled.div`
  height: 100%;
  width: 100%;
`;
```

### Render

Finally, create the `App` component:

```tsx
function App() {
    return (
        <Wrapper>
            <GlobalStyle/>
            <DAppProvider config={config}>
                <PollPage/>
            </DAppProvider>
        </Wrapper>
    )
}
```

Your `index.tsx` should now be:

```tsx
import {ChainId, DAppProvider, useEthers} from '@usedapp/core';
import {GlobalStyle, TopBar} from '@waku/vote-poll-sdk-react-components';
import React, {useEffect, useState} from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import {JsonRpcSigner} from "@ethersproject/providers";
import {orangeTheme} from "@waku/vote-poll-sdk-react-components/dist/cjs/src/style/themes";
import styled from 'styled-components'

const config = {
    readOnlyChainId: ChainId.Mainnet,
    readOnlyUrls: {
        [ChainId.Mainnet]: 'https://mainnet.infura.io/v3/your-infura-token',
    },
    multicallAddresses: {
        1: '0xeefba1e63905ef1d7acba5a8513c70307c1ce441',
        3: '0x53c43764255c17bd724f74c4ef150724ac50a3ed',
    },
    notifications: {
        checkInterval: 500,
        expirationPeriod: 50000,
    },
}

function PollPage() {
    const {account, library, activateBrowserWallet, deactivate} = useEthers()
    const [signer, setSigner] = useState<undefined | JsonRpcSigner>(undefined)

    useEffect(() => {
        if (account) {
            setSigner(library?.getSigner())
        } else {
            // Deactivate signer if signed out
            setSigner(undefined)
        }
    }, [account])

    return (
        <div>
            <TopBar
                logo={""}
                logoWidth={84}
                title={'Poll dApp'}
                theme={orangeTheme}
                activate={activateBrowserWallet}
                account={account}
                deactivate={deactivate}
            />
            //Place for poll or vote component
        </div>
    )
}

function App() {
    return (
        <Wrapper>
            <GlobalStyle/>
            <DAppProvider config={config}>
                <PollPage/>
            </DAppProvider>
        </Wrapper>
    )
}

const Wrapper = styled.div`
  height: 100%;
  width: 100%;
`;

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById("root")
);
```

{{< button relref="./02_connect_wallet"  >}}Back{{< /button >}}
