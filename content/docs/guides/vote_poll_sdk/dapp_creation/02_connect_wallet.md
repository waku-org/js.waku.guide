---
title: Connect to the Ethereum Wallet
date: 2022-01-03T11:00:00+1100
weight: 12
---

# Connect to the Ethereum Wallet

{{< hint info >}}
This section may be skipped if you are adding the poll feature to an existing dApp
that already connects to the user's wallet.
If you want to use `ethers` as a package to connect to web3 wallet you can follow this guide and skip the next step.
Next step demonstrates how to use `@useDapp` for this purpose.
{{< /hint >}}

In this we will use `ethers` to keep amount of dependencies to minimum but feel free to use other packages.

```shell
yarn add ethers@5.4.6
```

{{< hint warning >}}
The SDK use `ethers` version 5.4.6 due to incompatibility between minor versions it is recomended to use this version.
{{< /hint >}}

Delete the template `App` component:

```shell
rm -f App.tsx App.css App.test.tsx
```

## Hook for connecting to Wallet

In this example we will use this [hook](https://github.com/status-im/wakuconnect-vote-poll-sdk/blob/12bcd17c963106e9207b06182bc5f6379f771b99/examples/mainnet-poll/src/hooks/useWeb3Connect.ts) to connect to a Wallet.

Keep in mind this hook is barebones and can't handle multiple networks, in next chapter it will be shown how to use different web3 connector.

## Top bar

Use `TopBar` component to display wallet information.
For that, create a `PollPage` component that includes the top bar and will include the poll elements.
The component uses `ethers` to connect to the user's wallet:

```tsx
const MULTICALL_ADDRESS = '0xeefba1e63905ef1d7acba5a8513c70307c1ce441'
const SUPPORTED_CHAIN_ID = 1

export function MainPage() {
  const { activate, deactivate, account, provider } = useWeb3Connect(SUPPORTED_CHAIN_ID)

  return (
    <Wrapper>
      <TopBar
        logo={pollingIcon}
        logoWidth={84}
        title={'WakuConnect Poll Demo'}
        theme={orangeTheme}
        activate={activate}
        account={account}
        deactivate={deactivate}
      />
      //Place for poll or vote component
    </Wrapper>
  )
}
```

## Page

### Styled-components

[`styled-components`](https://styled-components.com/) is used for easy styling.
Create a `Wrapper` variable to use in the page component:

```tsx
import styled from 'styled-components'

const Wrapper = styled.div`
  height: 100%;
  width: 100%;
`
```

### Render

Finally, create the `App` component:

```tsx
export function App() {
  return (
    <Wrapper>
      <GlobalStyle />
      <MainPage/>
    </Wrapper>
  )
}
```

Your `index.tsx` should now be:

```tsx
import React from 'react'
import styled from 'styled-components'
import { Poll } from './components/Poll'
import { GlobalStyle, TopBar } from '@waku/vote-poll-sdk-react-components'
import pollingIcon from './assets/images/pollingIcon.png'
import { orangeTheme } from '@waku/vote-poll-sdk-react-components/dist/esm/src/style/themes'
import ReactDOM from 'react-dom'
import { BrowserRouter, useLocation } from 'react-router-dom'
import { Route, Switch } from 'react-router'
import { useWeb3Connect } from './hooks/useWeb3Connect'

const TOKEN_ADDRESS = '0x744d70FDBE2Ba4CF95131626614a1763DF805B9E'
const MULTICALL_ADDRESS = '0xeefba1e63905ef1d7acba5a8513c70307c1ce441'
const SUPPORTED_CHAIN_ID = 1

export function MainPage({ tokenAddress }: { tokenAddress: string }) {
  const { activate, deactivate, account, provider } = useWeb3Connect(SUPPORTED_CHAIN_ID)

  return (
    <Wrapper>
      <TopBar
        logo={pollingIcon}
        logoWidth={84}
        title={'WakuConnect Poll Demo'}
        theme={orangeTheme}
        activate={activate}
        account={account}
        deactivate={deactivate}
      />
      //Place for poll or vote component
    </Wrapper>
  )
}

export function App() {
  const location = useLocation()
  const tokenAddress = new URLSearchParams(location.search).get('token')

  return (
    <Wrapper>
      <GlobalStyle />
      <MainPage tokenAddress={tokenAddress ?? TOKEN_ADDRESS} />
    </Wrapper>
  )
}

const Wrapper = styled.div`
  height: 100%;
  width: 100%;
`

ReactDOM.render(
  <div style={{ height: '100%' }}>
    <BrowserRouter>
      <Switch>
        <Route exact path="/" component={App} />
      </Switch>
    </BrowserRouter>
  </div>,
  document.getElementById('root')
)
```

{{< button relref="./01_create_dapp"  >}}Back{{< /button >}}
{{< button relref="./03_connect_walle_useDapp"  >}}Next: Connect using useDapp{{< /button >}}
