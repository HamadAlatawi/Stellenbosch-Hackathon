# Stellenbosch-Hackathon Corruption Combat Coders

Welcome to the Donation Engine project and to the internet computer development community.

To get started, you might want to explore the project directory structure and the default configuration file. Working with this project in your development environment will not affect any production deployment or identity tokens.

To learn more before you start working with back_end and front_end, see the following documentation available online:

- [Quick Start](https://internetcomputer.org/docs/current/developer-docs/setup/deploy-locally)
- [SDK Developer Tools](https://internetcomputer.org/docs/current/developer-docs/setup/install)
- [Motoko Programming Language Guide](https://internetcomputer.org/docs/current/motoko/main/motoko)
- [Motoko Language Quick Reference](https://internetcomputer.org/docs/current/motoko/main/language-manual)
- [ckBTC and Bitcoin Integration](https://internetcomputer.org/docs/current/tutorials/developer-journey/level-4/4.3-ckbtc-and-bitcoin)
- [Svelte Front-End Framework](https://svelte.dev/)
- [Tailwind Styling System](https://tailwindcss.com/)
- [Shadcn-Svelte Component Library](https://www.shadcn-svelte.com/)


## The DFINITY Command-Line
____________________________________

This project utilizes The DFINITY command-line execution environment (dfx). The primary tool for creating, deploying, and managing, dapps that are developed in for the Internet Computer.


***Note that currently the dfx tool is not natively supported on windows.***

In order to use dfx on a Windows machine you'll need to download the Windows Subsystem for Linux (WSL). Refer to Microsoft's official guide [here](https://learn.microsoft.com/en-us/windows/wsl/install), and [here](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)


### Installing IC SDK and DFX

To install dfx run the following:

```bash
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
```

To verify that the IC SDK is successfully installed, run the following command:
```bash
dfx --version
```

It's recommended to create an identity using dfx. To set an identity and a key run the following command:

```bash
dfx identity new
```

Learn more about dfx identities here - [dfx identity](https://internetcomputer.org/docs/current/references/cli-reference/dfx-identity)


## Installing Bitcoin Core
_________________________________
The project requires bitcoin core to work. Download the relevant version for your system here:

[Download Bitcoin Core](https://bitcoin.org/en/download)

After downloading the bitcoin core, unpack it in your desired directory with the following command:

```
tar -xfz bitcoin-25.0-(rest of the file name)
```

Once it's been unzipped, navigate to the directory and create an empty directory called `data`.

```
cd bitcoin-25.0
mkdir data
```

Afterwards, using your prefered editor open the bitcoin.conf file located in the root bitcoin-25.0 directory and insert the following above the first line:

```
# Enable regtest mode. This is required to setup a private bitcoin network.
regtest=1

# Dummy credentials that are required by `bitcoin-cli`.
rpcuser=ic-btc-integration
rpcpassword=QPQiNaph19FqUsCrBRN0FII7lyM26B51fAMeBQzCb-E=
rpcauth=ic-btc-integration:cdf2741387f3a12438f69092f0fdad8e$62081498c98bee09a0dce2b30671123fa561932992ce377585e8e08bb0c11dfa
```

## Starting the project


--------------------------------------
If you want to start working on your project, run the following commands:

Open three separate terminals and in each terminal run:

```bash
# Terminal 1
cd bitcoin-25.0/
./bin/bitcoind -conf=$(pwd)/bitcoin.conf -datadir=$(pwd)/data --port=18444
```

```bash
# Terminal 2
cd ..
npm run generate
npm run startdfx
```

```bash
# Terminal 3
npm run deploy
```

This will build and deploy the project locally.

## Running the project locally with Hot Module Replacement

If you want to test your project locally with Hot Module Replacement (HMR), you can use the following commands:

```bash
# Terminal 1
cd bitcoin-25.0/
./bin/bitcoind -conf=$(pwd)/bitcoin.conf -datadir=$(pwd)/data --port=18444
```

```bash
# Terminal 2
cd ..
npm run generate
npm run startdfx
```

```bash
# Terminal 3
npm run deploy
npm run dev
```

Using svelte's native localhost:5173 local server you can now edit your code with HMR without the need to rebuild the files to see changes.

## Deploying to IC

Todo

## Design Documents

todo

[architecture design]()

[UI mockups]()

[data designs]()

[flow diagrams]()

[interaction diagrams]()