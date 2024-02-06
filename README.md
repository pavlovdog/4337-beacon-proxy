# ERC4337 compatible beacon proxy

This repo contains a set of Solidity smart contracts for implementing smart accounts, compatible with both beacon proxy pattern and ERC4337.
Made by [fastfourier.eth](https://warpcast.com/fastfourier.eth).

## Introduction

Using a beacon proxy within the ERC4337 compatible system may be tricky since the naive implementation will violate the EIP rules in multiple ways.

## Overview

## FAQ

### Is there an example of using these contracts with an AA bundler?

Check out the [4337-beacon-proxy-stackup-example](https://github.com/pavlovdog/4337-beacon-proxy-stackup-example).

### How can I implement a custom smart account by using these contracts?

Most likely you can use `sample/AccountFactory` and `sample/AccountBeaconProxy` right out of the box. All you need to do is to carefully implement your version of `sample/Account.sol`.

## Testing

```bash
yarn
yarn hh:test
```

## Credits

- [John Rising](https://twitter.com/johnrising_)