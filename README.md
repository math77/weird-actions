# Weird Actions

An attempt to build a set of action contracts for NFTs. Each action is composed of contracts that are deployed by artists and creators activating self-sovereignty. The ultimate goal is to have more tools for creators to experiment beyond the current default mint().

## Actions

### MergeNFT

It allows artists and creators to implement a mint new NFT contract based on the merger of another NFTs.

The creator must set how many NFTs need to be merged by the user in order to receive a new NFT, which collection the NFTs that must be merged come from and what happens to the NFTs after they are merged.

Among the possibilities of what happens to NFTs that have been merged are:
* The NFTs are burned
* NFTs are locked into the merger contract