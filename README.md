# Weird Actions

An attempt to build a set of action contracts for NFTs. Each action is composed of contracts that are deployed by artists and creators activating self-sovereignty. The ultimate goal is to have more tools for creators to experiment beyond the current default mint().

## Actions

### MergeNFT

It allows artists and creators to implement a mint new NFT contract based on the merger of another NFTs.

The creator must set how many NFTs need to be merged by the user in order to receive a new NFT, which collection the NFTs that must be merged come from and what happens to the NFTs after they are merged.

Among the possibilities of what happens to NFTs that have been merged are:
* The NFTs are burned
* NFTs are locked into the merger contract


### Friend-invite Mint

It allows artists and creators to implement a mint-invite based minting process.

The process works this way:

* The token #1 of the collection is minted by the artist/creator.
* When minting token #1 the artist/creator indicates the address of the next user who can mint token #2
* When the user mints token #2 it indicates the address of the user who can mint token #3
* The process continues until the maximum supply of the collection is reached.


### Friend-payed-invite Mint

Same process as the mint-invite action above, but with the possibility for the user who is minting the current token to pay the mint value of the token of the user he is inviting to mint.
