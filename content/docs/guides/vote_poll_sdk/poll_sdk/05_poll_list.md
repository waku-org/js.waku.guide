---
title: Poll List Component
date: 2022-01-03T11:00:00+1100
weight: 15
---

# Poll List Component

To display existing polls, the `PollList` component is provided.

Simply add it to the `Poll` function to render it.
It needs the `account` variable that can be passed as a property to `Poll`:

`components/Poll.tsx`:
```tsx
import {useState} from 'react'
import {useConfig} from '@usedapp/core'
import {PollCreation, PollList} from '@waku/poll-sdk-react-components'
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
    account: string | null | undefined
    theme: Theme
    tokenAddress: string
}

export function Poll({appName, library, signer, chainId, account, theme, tokenAddress}: PollProps) {
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
            <PollList wakuPolling={wakuPolling} account={account} theme={theme} />
        </Wrapper>
    )
}
```

Pass the `account` to `Poll` in `index.tsx`:
```tsx
 <Poll theme={orangeTheme} appName={'demo-poll-dapp'} library={library} signer={signer} chainId={chainId}
                  account={account}
                  tokenAddress={'0x744d70FDBE2Ba4CF95131626614a1763DF805B9E'}/>
```

Et voila!
The `PollList` component handles the display of polls:

![Poll List](/assets/poll_sdk/listed-polls.png)

And answering them:

![Poll list with answered](/assets/poll_sdk/listed-polls-with-answer.png)

You can find the resulting code in the [examples folder](https://github.com/status-im/wakuconnect-vote-poll-sdk/tree/main/examples/mainnet-poll).

{{< hint info >}}
The example above uses webpack 5 instead of react-app-rewired.
It also allows passing a token contract address in the url, as described in the [README](https://github.com/status-im/wakuconnect-vote-poll-sdk/blob/main/examples/mainnet-poll/README.md). 
{{< /hint >}}

The final gif:

![Poll demo](/assets/poll_sdk/wakuconnect-poll-demo.gif)


{{< button relref="./04_poll_creation"  >}}Back{{< /button >}}
