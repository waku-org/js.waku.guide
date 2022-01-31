---
title: Use Voting component
date: 2022-01-03T11:00:00+1100
weight: 3
---

# Use Voting Component

## Define Configuration

Configure the dApp by setting:

- Address of the multicall smart contract of the target chain,
- Address of the voting smart contract,
- Your dApp name.

```tsx
const VOTING_ADDRESS = 'VOTING_ADDRESS'
const MULTICALL_ADDRESS = 'MULTICALL_ADDRESS'
const DAPP_NAME = 'YOUR_DAPP_NAME'
```

## Using Waku Voting

Now, we need a Waku voting object.
For that, call `useWakuVoting`:

```tsx
import {useWakuVoting} from '@waku/vote-sdk-react-hooks'

export function MainPage() {
    const {activate, deactivate, account, provider} = useWeb3Connect(SUPPORTED_CHAIN_ID)
    const wakuVoting = useWakuVoting(
        DAPP_NAME,
        VOTING_ADDRESS,
        provider,
        MULTICALL_ADDRESS
    )
}
```

## Display Voting Component 

Modify the `MainPage` to render a Voting component.
Before rendering the component, check if `wakuVoting` has initialized:

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

## Resulting `index.tsx` File

Your `index.tsx` should now look like:

```tsx
import React from 'react'
import styled from 'styled-components'
import {GlobalStyle, TopBar} from '@waku/vote-poll-sdk-react-components'
import {blueTheme} from '@waku/vote-poll-sdk-react-components/dist/esm/src/style/themes'
import ReactDOM from 'react-dom'
import {useWeb3Connect} from './hooks/useWeb3Connect'
import {Voting} from './components/Voting'
import {useWakuVoting} from '@waku/vote-sdk-react-hooks'

const VOTING_ADDRESS = '0xCA4093D66280Ec1242b660088188b50fDC14dcC4'
const MULTICALL_ADDRESS = '0x53c43764255c17bd724f74c4ef150724ac50a3ed'
const DAPP_NAME = 'test'
const SUPPORTED_CHAIN_ID = 3

export function MainPage() {
    const {activate, deactivate, account, provider} = useWeb3Connect(SUPPORTED_CHAIN_ID)
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
            <GlobalStyle/>
            <MainPage/>
        </Wrapper>
    )
}

const Wrapper = styled.div`
  height: 100%;
  width: 100%;
`

ReactDOM.render(
    <div style={{height: '100%'}}>
        <App/>
    </div>,
    document.getElementById('root')
)
```

After starting a page you should be able to see a main page that looks like this:
![Main Page](/assets/voting_sdk/Voting_Main_Page.png)


Creating proposal should be as seen in this gif:
![Proposal creation](/assets/voting_sdk/proposal_creation.gif)

After voting with a second account on proposal the proposal card should look like this:
![Proposal Card](/assets/voting_sdk/proposal_card.png)

{{< button relref="./02_voting_creation"  >}}Back{{< /button >}}
