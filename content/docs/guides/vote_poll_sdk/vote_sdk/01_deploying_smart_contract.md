---
title: Deploy smart contract
date: 2022-01-03T11:00:00+1100
weight: 1
---

# Deploy smart contract

## Creating new package

For this deployment we will create a new package.

```shell
mkdir contract-deployment
cd contract-deployment
yarn init
yarn add @waku/vote-sdk-contracts ethers ts-node typescript
```

Create a `tsconfig.json` with:

```json
{
  "compilerOptions": {
    "target": "es2020",
    "module": "commonJS",
    "esModuleInterop": true,
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "noEmit": true
  }
}
```

And now we can add a deploy script `index.ts`:

```js
import { ContractFactory, getDefaultProvider, Wallet } from "ethers";
import VotingContract from "@waku/vote-sdk-contracts/build/VotingContract.json";
import readline from "readline";

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});
const prompt = (query: string) =>
  new Promise((resolve) => rl.question(query, resolve));

try {
  const privateKey = process.argv[2];
  const providerName = process.argv[3];
  const tokenAddress = process.argv[4];
  const voteDuration = process.argv[5];
  const provider = getDefaultProvider(providerName);
  const wallet = new Wallet(privateKey, provider);
  const contract = ContractFactory.fromSolidity(VotingContract, wallet);

  new Promise(async () => {
    console.log("\x1b[1m");
    console.log(`You are about to deploy a voting smart contract\n`);
    console.log(`Wallet address: \t${wallet.address}\n`);
    console.log(`Provider name: \t\t${provider.network.name}\n`);
    console.log(`Provider chainID: \t${provider.network.chainId}\n`);
    console.log(`Token address to use: \t${tokenAddress}\n`);
    console.log(`Vote duration: \t\t${voteDuration ?? 1000} seconds\n`);
    console.log("Please verify that above parameters are correct");
    console.log("WARNING: this operation WILL use ether");
    const answer = await prompt(
      "If you are sure that you want to continue write [yes]:"
    );
    if (answer === "yes" || answer === "Yes") {
      const deployedContract = await contract.deploy(
        tokenAddress,
        voteDuration ?? 1000
      );
      console.log(`contract deployed with address ${deployedContract.address}`);
    } else {
      console.log("Aborted");
    }
    rl.close();
  });
} catch {
  console.log("Error creating smart contract");
  rl.close();
}
```

## Running script

To run deploying script we call in shell:

```shell
yarn ts-node index.ts WALLET_PRIVATE_KEY PROVIDER_NAME TOKEN_ADDRESS VOTING_DURATION
```

you need to substitute parameters:

- WALLET_PRIVATE_KEY: private key of wallet that will deploy smart contract
- PROVIDER_NAME: a name of network for example `mainnet`, `ropsten` or an url to network
- TOKEN_ADDRESS: address of a token that is to be used by voting contract
- VOTING_DURATION: how long proposals will be open to accept votes

After that the information with input parameters will be displayed,
and you will be asked to verify them and accept them.

## Getting smart contract address

When the script is complete smart contract address will be printed in the shell.
If you missed it, you can check last wallet interaction on Etherscan and there you can also find new smart contract address.

{{< button relref="./"  >}}Back{{< /button >}}
{{< button relref="./02_voting_creation"  >}}Next: Create Voting component{{< /button >}}
