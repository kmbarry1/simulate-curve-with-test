# Simulating Curve Pools Using the Actual Implementation

This repo is a proof of concept of how to deploy a Curve pool in a Foundry Solidity test.

Install Foundry: https://book.getfoundry.sh/getting-started/installation

Run to see output:
`forge test -vv --fork-url <ETH RPC URL>`

There is a lot that can be done based on this PoC, especially if leveraging the various Foundry cheat codes: https://book.getfoundry.sh/cheatcodes/ .

The downside of basing an analysis on this is that solving, say, for the A parameter as a function of slippage for a 
given swap size has to be done iteratively using something like a binary search, whereas if you're just reimplementing
Curve pools in Python, you can easily write a one-and-done function for it (and have access to innumerable Python math
libraries besies). The advantage of basing an analysis on this is that you are sure you are perfectly modeling the behavior
of a Curve pool because you are using the EVM bytecode implementation as your source of truth.
