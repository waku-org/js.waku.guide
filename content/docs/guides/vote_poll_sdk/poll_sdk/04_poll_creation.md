---
title: Poll Creation Component
date: 2022-01-03T11:00:00+1100
weight: 14
---

# Poll Creation Component

The Poll SDK provide an off-the-shelf component to create a new poll: `PollCreation`.
It takes in a `WakuPolling` hook that can created with `useWakuPolling`.

`useWakuPolling` takes:
- `appName`: Your app name.
  It is used to generate a unique content topic for your polls. 
  See [How to Choose a Content Topic](/docs/guides/01_choose_content_topic/) for more information.
- `tokenAddress`: The address of your ERC-20 token.
  Only token holders can create and answer polls.
- `provider`: The Web3 provider to access the blockchain.
- `multicallAddress`: Address to this blockchain's multicall contract.

Add these parameters to `PollProps` and call `useWakuPolling`.

`components/Poll.tsx`
```tsx
import {useState} from 'react'
import {useConfig} from '@usedapp/core'
import {PollCreation} from '@waku/poll-sdk-react-components'
import {JsonRpcSigner, Web3Provider} from '@ethersproject/providers'
import {useWakuPolling} from '@waku/poll-sdk-react-hooks'
import {CreateButton} from '@waku/vote-poll-sdk-react-components'
import {Theme} from '@waku/vote-poll-sdk-react-components/dist/esm/src/style/themes'
import {ChainId} from "@usedapp/core/src/constants";

type PollProps = {
    appName: string
    library: Web3Provider | undefined
    signer: JsonRpcSigner | undefined
    chainId: ChainId | undefined
    theme: Theme
    tokenAddress: string
}

export function Poll({appName, library, signer, chainId, theme, tokenAddress}: PollProps) {
    const config = useConfig()
    const [showPollCreation, setShowPollCreation] = useState(false)
    const wakuPolling = useWakuPolling(appName, tokenAddress, library, config?.multicallAddresses?.[chainId ?? 1337])

    const disabled = !signer;

    return (
        <Wrapper>
            {showPollCreation && signer && (
                <PollCreation wakuPolling={wakuPolling} setShowPollCreation={setShowPollCreation} theme={theme}/>
            )}
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

Then pass them in `PollPage`.

In this example, we use `demo-poll-dapp` for the app name and the mainnet SNT token contract for the token address.
Replace those with your own.

`index.tsx`
```tsx
export function PollPage() {
    const {account, library, activateBrowserWallet, deactivate, chainId} = useEthers()
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
            <Poll theme={orangeTheme} appName={'demo-poll-dapp'} library={library} signer={signer} chainId={chainId}
                  tokenAddress={'0x744d70FDBE2Ba4CF95131626614a1763DF805B9E'}/>
        </div>
    )
}
```

You can now see the poll creation modal when clicking on the button:

![Create a poll modal](/assets/poll_sdk/create-a-poll-component.png)

![Confirmation modal](/assets/poll_sdk/poll-created.png)

{{< button relref="./03_create-a-poll_button"  >}}Back{{< /button >}}
{{< button relref="./05_poll_list"  >}}Next: Poll List Component{{< /button >}}
