# TODO: set header

## Final result

`components/WakuPolling.tsx`
```tsx
import React, { useState } from 'react'
import { useConfig, useEthers } from '@usedapp/core'

import { PollList, PollCreation } from '@waku/poll-sdk-react-components'
import { JsonRpcSigner } from '@ethersproject/providers'
import { useWakuPolling } from '@waku/poll-sdk-react-hooks'
import { Modal, Networks, CreateButton } from '@waku/vote-poll-sdk-react-components'
import { Theme } from '@waku/vote-poll-sdk-react-components/dist/esm/src/style/themes'

type WakuPollingProps = {
  appName: string
  signer: JsonRpcSigner | undefined
  theme: Theme
  tokenAddress: string
}

export function WakuPolling({ appName, signer, theme, tokenAddress }: WakuPollingProps) {
  const { activateBrowserWallet, account, library, chainId } = useEthers()
  const config = useConfig()
  const [showPollCreation, setShowPollCreation] = useState(false)
  const [selectConnect, setSelectConnect] = useState(false)
  const wakuPolling = useWakuPolling(appName, tokenAddress, library, config?.multicallAddresses?.[chainId ?? 1337])
  return (
    <div>
      {showPollCreation && signer && (
        <PollCreation wakuPolling={wakuPolling} setShowPollCreation={setShowPollCreation} theme={theme} />
      )}
      {account ? (
        <CreateButton theme={theme} disabled={!signer} onClick={() => setShowPollCreation(true)}>
          Create a poll
        </CreateButton>
      ) : (
        <CreateButton
          theme={theme}
          onClick={() => {
            if ((window as any)?.ethereum) {
              activateBrowserWallet()
            } else setSelectConnect(true)
          }}
        >
          Connect to vote
        </CreateButton>
      )}
      {selectConnect && (
        <Modal heading="Connect" theme={theme} setShowModal={setSelectConnect}>
          <Networks />
        </Modal>
      )}

      <PollList wakuPolling={wakuPolling} account={account} theme={theme} />
    </div>
  )
}
```

`index.tsx`
```tsx
import React, { useEffect, useState } from 'react'
import { DAppProvider, ChainId, useEthers } from '@usedapp/core'
import { DEFAULT_CONFIG } from '@usedapp/core/dist/cjs/src/model/config/default'
import { WakuPolling } from './components/WakuPolling'
import { TopBar, GlobalStyle } from '@waku/vote-poll-sdk-react-components'
import pollingIcon from './assets/images/pollingIcon.png'
import { JsonRpcSigner } from '@ethersproject/providers'
import { orangeTheme } from '@waku/vote-poll-sdk-react-components/dist/esm/src/style/themes'
import ReactDOM from 'react-dom'
import { BrowserRouter } from 'react-router-dom'
import { Route, Switch } from 'react-router'
import { useLocation } from 'react-router-dom'

const sntTokenAddress = '0x744d70FDBE2Ba4CF95131626614a1763DF805B9E'

const config = {
  readOnlyChainId: ChainId.Mainnet,
  readOnlyUrls: {
    [ChainId.Mainnet]: 'https://mainnet.infura.io/v3/b4451d780cc64a078ccf2181e872cfcf',
  },
  multicallAddresses: {
    1: '0xeefba1e63905ef1d7acba5a8513c70307c1ce441',
    3: '0x53c43764255c17bd724f74c4ef150724ac50a3ed',
    1337: process.env.GANACHE_MULTICALL_CONTRACT ?? '0x0000000000000000000000000000000000000000',
  },
  supportedChains: [...DEFAULT_CONFIG.supportedChains, 1337],
  notifications: {
    checkInterval: 500,
    expirationPeriod: 50000,
  },
}

export function Polling({ tokenAddress }: { tokenAddress: string }) {
  const { account, library, activateBrowserWallet, deactivate } = useEthers()
  const [signer, setSigner] = useState<undefined | JsonRpcSigner>(undefined)

  useEffect(() => {
    setSigner(library?.getSigner())
  }, [account])

  return (
    <div>
      <TopBar
        logo={pollingIcon}
        logoWidth={84}
        title={'WakuConnect Poll Demo'}
        theme={orangeTheme}
        activate={activateBrowserWallet}
        account={account}
        deactivate={deactivate}
      />
      <WakuPolling theme={orangeTheme} appName={'my-dapp'} signer={signer} tokenAddress={tokenAddress} />
    </div>
  )
}

export function PollingPage() {
  const location = useLocation()
  const tokenAddress = new URLSearchParams(location.search).get('token')

  return (
    <div>
      <GlobalStyle />
      <DAppProvider config={config}>
        <Polling tokenAddress={tokenAddress ?? sntTokenAddress} />
      </DAppProvider>
    </div>
  )
}

ReactDOM.render(
  <div style={{ height: '100%' }}>
    <BrowserRouter>
      <Switch>
        <Route exact path="/" component={PollingPage} />
      </Switch>
    </BrowserRouter>
  </div>,
  document.getElementById('root')
)
```
