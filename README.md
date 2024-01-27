# Stellenbosch-Hackathon Corruption Combat Coders

Welcome to your new Donation Engine project and to the internet computer development community. By default, creating a new project adds this README and some template files to your project directory. You can edit these template files to customize your project and to include your own code to speed up the development cycle.

To get started, you might want to explore the project directory structure and the default configuration file. Working with this project in your development environment will not affect any production deployment or identity tokens.

To learn more before you start working with back_end, see the following documentation available online:

- [Quick Start](https://internetcomputer.org/docs/current/developer-docs/setup/deploy-locally)
- [SDK Developer Tools](https://internetcomputer.org/docs/current/developer-docs/setup/install)
- [Motoko Programming Language Guide](https://internetcomputer.org/docs/current/motoko/main/motoko)
- [Motoko Language Quick Reference](https://internetcomputer.org/docs/current/motoko/main/language-manual)

If you want to start working on your project right away, you might want to try the following commands:
Open three separate terminals and in each terminal run:
```bash
cd bitcoin-25.0/
./bin/bitcoind -conf=$(pwd)/bitcoin.conf -datadir=$(pwd)/data --port=18444
```

```bash
cd ..
npm run generate
npm run startdfx
```

```bash
npm run deploy
```

## Running the project locally

If you want to test your project locally with Hot Module Replacement, you can use the following commands:

```bash
cd bitcoin-25.0/
./bin/bitcoind -conf=$(pwd)/bitcoin.conf -datadir=$(pwd)/data --port=18444
```

```bash
cd ..
npm run generate
npm run startdfx
```

```bash
npm run dev
```

## Deploying to IC

Todo