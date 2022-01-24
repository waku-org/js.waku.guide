---
title: Creating Voting component
date: 2022-01-03T11:00:00+1100
weight: 13
---

# Defining config

First thing we need to do is to set address of multicall smart contract and voting smart contract.
And also your dapp name.

```tsx
const VOTING_ADDRESS = 'VOTING_ADDRESS'
const MULTICALL_ADDRESS = 'MULTICALL_ADDRESS'
const DAPP_NAME = 'YOUR_DAPP_NAME'
```

# Using waku voting

Now we need to have a waku voting object to do that we simply call `useWakuVoting`:

```tsx
import { useWakuVoting } from '@waku/vote-sdk-react-hooks'

export function MainPage() {
  const { activate, deactivate, account, provider } = useWeb3Connect(SUPPORTED_CHAIN_ID)
  const wakuVoting = useWakuVoting(
    DAPP_NAME,
    VOTING_ADDRESS,
    provider,
    MULTICALL_ADDRESS
  )
```

# Showing Voting component 

Now we can modify what `MainPage` returns so that it shows a Voting component, before showing Voting component we need to check if wakuVoting has initialized:

```tsx
  return (
    <Wrapper>
      <TopBar
        logo={''}
        logoWidth={84}
        title={'WakuConnect Vote Demo'}
        theme={blueTheme}
        activate={activate}
        account={account}
        deactivate={deactivate}
      />
      {wakuVoting &&
        <Voting
          wakuVoting={wakuVoting}
          account={account}
          activate={activate}
        />}
    </Wrapper>
  )
```

# Final look of index file

After all that `index.tsx` should look similar to this:

```tsx
import React from 'react'
import styled from 'styled-components'
import { GlobalStyle, TopBar } from '@waku/vote-poll-sdk-react-components'
import { blueTheme } from '@waku/vote-poll-sdk-react-components/dist/esm/src/style/themes'
import ReactDOM from 'react-dom'
import { useWeb3Connect } from './hooks/useWeb3Connect'
import { Voting } from './components/Voting'
import { useWakuVoting } from '@waku/vote-sdk-react-hooks'

const VOTING_ADDRESS = '0xCA4093D66280Ec1242b660088188b50fDC14dcC4'
const MULTICALL_ADDRESS = '0x53c43764255c17bd724f74c4ef150724ac50a3ed'
const DAPP_NAME = 'test'
const SUPPORTED_CHAIN_ID = 3

export function MainPage() {
  const { activate, deactivate, account, provider } = useWeb3Connect(SUPPORTED_CHAIN_ID)
  const wakuVoting = useWakuVoting(
    DAPP_NAME,
    VOTING_ADDRESS,
    provider,
    MULTICALL_ADDRESS
  )

  return (
    <Wrapper>
      <TopBar
        logo={''}
        logoWidth={84}
        title={'WakuConnect Vote Demo'}
        theme={blueTheme}
        activate={activate}
        account={account}
        deactivate={deactivate}
      />
      {wakuVoting &&
        <Voting
          wakuVoting={wakuVoting}
          account={account}
          activate={activate}
        />}
    </Wrapper>
  )
}

export function App() {
  return (
    <Wrapper>
      <GlobalStyle />
      <MainPage />
    </Wrapper>
  )
}

const Wrapper = styled.div`
  height: 100%;
  width: 100%;
`

ReactDOM.render(
  <div style={{ height: '100%' }}>
    <App />
  </div>,
  document.getElementById('root')
)
```

Gif with proposal creation:



{{< button relref="./02_voting_creation"  >}}Back{{< /button >}}
{{< button relref="./"  >}}Back{{< /button >}}

