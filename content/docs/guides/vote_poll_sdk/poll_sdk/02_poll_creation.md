---
title: Poll Creation Component
date: 2022-01-03T11:00:00+1100
weight: 14
---

# Poll Creation Component

The Poll SDK provides an off-the-shelf component to create a new poll: `PollCreation`.
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
import React, { useMemo, useState } from "react";
import styled from "styled-components";
import { PollCreation } from "@waku/poll-sdk-react-components";
import { Web3Provider } from "@ethersproject/providers";
import { useWakuPolling } from "@waku/poll-sdk-react-hooks";
import { CreateButton } from "@waku/vote-poll-sdk-react-components";
import { Theme } from "@waku/vote-poll-sdk-react-components/dist/esm/src/style/themes";

type PollProps = {
  appName: string;
  library: Web3Provider | undefined;
  account: string | null | undefined;
  theme: Theme;
  tokenAddress: string;
  multicallAddress: string;
};

export function Poll({
  appName,
  library,
  signer,
  chainId,
  theme,
  tokenAddress,
}: PollProps) {
  const [showPollCreation, setShowPollCreation] = useState(false);
  const wakuPolling = useWakuPolling(
    appName,
    tokenAddress,
    library,
    multicallAddress
  );
  const disabled = useMemo(() => !account, [account]);

  return (
    <Wrapper>
      {showPollCreation && signer && (
        <PollCreation
          wakuPolling={wakuPolling}
          setShowPollCreation={setShowPollCreation}
          theme={theme}
        />
      )}
      {
        <CreateButton
          style={{
            backgroundColor: disabled ? "lightgrey" : theme.primaryColor,
          }}
          theme={theme}
          disabled={disabled}
          onClick={() => setShowPollCreation(true)}
        >
          Create a poll
        </CreateButton>
      }
    </Wrapper>
  );
}
```

Then pass them in `MainPage`.

In this example, we use `demo-poll-dapp` for the app name and the mainnet SNT token contract for the token address.
Replace those with your own.

`TOKEN_ADDRESS` can be any ERC20 token that will be used to token gate people from voting and creating polls.

`index.tsx`

```tsx
const TOKEN_ADDRESS = "0x744d70FDBE2Ba4CF95131626614a1763DF805B9E";
const MULTICALL_ADDRESS = "0xeefba1e63905ef1d7acba5a8513c70307c1ce441";
export function MainPage() {
  const { activate, deactivate, account, provider } =
    useWeb3Connect(SUPPORTED_CHAIN_ID);

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
      <Poll
        theme={orangeTheme}
        appName={"demo-poll-dapp"}
        library={provider}
        account={account}
        tokenAddress={TOKEN_ADDRESS}
        multicallAddress={MULTICALL_ADDRESS}
      />
    </div>
  );
}
```

{{< hint info >}}
If you are using ethers web3 connector it is recommended to only render `Poll` component if provider is not undefined.
{{< /hint >}}

You can now see the poll creation modal when clicking on the button:

![Create a poll modal](/assets/poll_sdk/create-a-poll-component.png)

![Confirmation modal](/assets/poll_sdk/poll-created.png)

{{< button relref="./01_create-a-poll_button"  >}}Back{{< /button >}}
{{< button relref="./03_poll_list"  >}}Next: Poll List Component{{< /button >}}
