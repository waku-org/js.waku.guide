---
title: Creating Voting component
date: 2022-01-03T11:00:00+1100
weight: 13
---

With smart contract deployed we can go back to our dapp.

On this step base dapp with wallet connection should be done if not please refer to `dapp creation`.

# Creating Voting component

Let's start by creating a new folder `components` with file named `Voting.tsx` inside.

After that we can start with styling and defining which theme we will be using:

```tsx
import { blueTheme } from '@waku/vote-poll-sdk-react-components/dist/esm/src/style/themes'
import styled from 'styled-components'

const THEME = blueTheme;

const Wrapper = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  max-width: 1000px;
  margin: 0 auto;
  padding: 150px 32px 50px;
  width: 100%;
  min-height: 100vh;

  @media (max-width: 600px) {
    padding: 132px 16px 32px;
  }

  @media (max-width: 425px) {
    padding: 64px 16px 84px;
  }
`
```

# Adding react component

Now 

```tsx
import React, { useCallback, useState } from 'react'
import {
  VotingRoomListHeader,
  VotingRoomList,
  NewVotingRoomModal,
} from '@waku/vote-sdk-react-components'
import { WakuVoting } from '@waku/vote-poll-sdk-core'
import { useVotingRoomsId } from '@waku/vote-sdk-react-hooks'
import { useTokenBalance } from '@waku/vote-poll-sdk-react-components'

type VotingProps = {
  wakuVoting: WakuVoting
  account: string | null | undefined
  activate: () => void
}

export function Voting({ wakuVoting, account, activate }: VotingProps) {
  const [showNewVoteModal, setShowNewVoteModal] = useState(false)
  const onCreateClick = useCallback(() => {
    setShowNewVoteModal(true)
  }, [])

  const votes = useVotingRoomsId(wakuVoting)
  const tokenBalance = useTokenBalance(account, wakuVoting)

  return (
    <Wrapper>
      <NewVotingRoomModal
        theme={THEME}
        availableAmount={tokenBalance}
        setShowModal={setShowNewVoteModal}
        showModal={showNewVoteModal}
        wakuVoting={wakuVoting}
      />
      <VotingRoomListHeader
        account={account}
        theme={THEME}
        onConnectClick={activate}
        onCreateClick={onCreateClick}
      />
        <VotingRoomList
          account={account}
          theme={THEME}
          wakuVoting={wakuVoting}
          votes={votes}
          availableAmount={tokenBalance}
        />
    </Wrapper>
  )
}
```

With that voting component is complete now we can use it in our `MainPage`

{{< button relref="./01_deploying_smart_contract"  >}}Back{{< /button >}}
{{< button relref="./03_using_voting"  >}}Next: Using Voting{{< /button >}}

