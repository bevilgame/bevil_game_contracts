<p align="center">
<a href="https://bevil.io" target="_blank" rel="noopener noreferrer"><img width="100"  src="https://img.bevil.io/resources/BEV.png" alt="Bevil logo"></a>
<a href="https://bevil.io" target="_blank" rel="noopener noreferrer"><img width="100"  src="https://img.bevil.io/resources/MAT.png" alt="Bevil logo"></a>
</p>

<p align="center">
  <a href="https://github.com/bevilgame"><img src="https://img.shields.io/codecov/c/github/vuejs/vue/dev.svg?sanitize=true" alt="Chat"></a>
  <a href="https://www.youtube.com/channel/UCuSyLsNuPuQew10YhrboTLw"><img src="https://img.shields.io/youtube/channel/views/UCuSyLsNuPuQew10YhrboTLw" alt="License"></a>
  <a href="https://twitter.com/bevil_gamefi"><img src="https://img.shields.io/twitter/follow/bevil_gamefi" alt="Build Status"></a>
</p>


## Bevil Game Contracts
Bevil Game (BEV) is a completely decentralized game platform. It creates a completely fair and transparent game platform by leveraging the non-tamperable and data transparent characteristics of the blockchain, plus the uniqueness of NFT and the autonomy of DAO.

## Introduction
These heroes are the NFT of Bevil, and each hero has his own stats, ATK, health, Magic, etc.
<p align="center">
  <a target="_blank" href="https://bevil.io/">
    <img alt="sponsors" src="https://img.bevil.io/resources/heros.png">
  </a>
</p>

## How to play？
please see the [Official GUI Documentation](https://bevil.io/) for rules, guides and tips .



### Development
We welcome pull requests. To get started, just fork this repo, clone it locally, and run:

### 1. install some dependencies
```shell

# install dependencies
npm:
$ npm i

yarn:
$ yarn install
```

### 2. run and deploy
```shell
# compile contracts
$ npm run compile

# run uint test
$ npm run test

# deploy contract
$ npm run migrate
```

### 3. config env see the truffle-config.js
Configure a local open environment

### Documentation
How to config?
please see the [Official GUI Documentation](https://trufflesuite.com/docs/truffle/) for guides.


### 4. deploy on truffle
```shell
$ truffle develop 

truffle(develop)> compile   

truffle(develop)> test

truffle(develop)> migrate
```

### License
[MIT](https://opensource.org/licenses/MIT)
