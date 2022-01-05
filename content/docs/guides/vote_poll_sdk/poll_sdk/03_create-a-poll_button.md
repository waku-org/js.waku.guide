---
title: Create-A-Poll Button
date: 2022-01-03T11:00:00+1100
weight: 13
---

# Create-A-Poll Button

Create the `Poll` component,
it will allow the user to create a new poll, view polls and answer them.
We'll start by adding a button to create a poll.

```shell
mkdir components
touch components/Poll.tsx
```

## Styled-components

Again, create a `Wrapper` for styling:

```tsx
import styled from 'styled-components'

const Wrapper = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  max-width: 1146px;
  position: relative;
  margin: 0 auto;
  padding: 150px 32px 50px;
  width: 100%;
  @media (max-width: 1146px) {
    max-width: 780px;
  }
  @media (max-width: 600px) {
    padding: 132px 16px 32px;
  }
  @media (max-width: 425px) {
    padding: 96px 16px 84px;
  }
`
```

## Button

Create a button that will display the `PollCreation` component on click.
To create a poll, we need access to the wallet,
thus the button must be disabled if the wallet is not connected.

The button is disabled if `signer` is undefined.
To give a visual clue to the user, also make the button grey when disabled.

Upon clicking the button, we set `showPollCreation` to true.
`showPollCreation` will control when to render the poll creation modal.

`components/Poll.tsx`:
```tsx
import {useState} from 'react'
import {JsonRpcSigner, Web3Provider} from '@ethersproject/providers'
import {CreateButton} from '@waku/vote-poll-sdk-react-components'
import {Theme} from '@waku/vote-poll-sdk-react-components/dist/esm/src/style/themes'

type PollProps = {
    signer: JsonRpcSigner | undefined
    theme: Theme
}

export function Poll({signer, theme}: PollProps) {
    const [showPollCreation, setShowPollCreation] = useState(false)

    const disabled = !signer;

    return (
        <Wrapper>
            {
                <CreateButton style={{backgroundColor: disabled ? "lightgrey" : theme.primaryColor}} theme={theme}
                              disabled={disabled}
                              onClick={() => setShowPollCreation(true)}>
                    Create a poll
                </CreateButton>
            }
        </Wrapper>
    )
}
```

Now update the `PollPage` component to render the new `Poll` component:

`index.tsx`:
```tsx
export function PollPage() {
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
            <Poll theme={orangeTheme} signer={signer}/>
        </div>
    )
}
```

Now, you have a button:

![Create a poll button](/assets/poll_sdk/create-poll-button.png)

{{< button relref="./02_connect_wallet"  >}}Back{{< /button >}}
{{< button relref="./04_poll_creation"  >}}Next: Poll Creation Component{{< /button >}}
