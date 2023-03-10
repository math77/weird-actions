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


### Give to the "bazaar" to mint

It allows artists/creators to create a minting process where collectors need to send an NFT from those accepted by the bazaar in order to mint a new NFT in the current collection.

Something like:

* Creators set which collections they accept NFTs from for the bazaar
* When minting a new NFT in the current collection, users must send an NFT from one of the collections accepted by the bazaar
* After all tokens in the current collection are minted, the NFTs in the bazaar are put up for "direct" sale.
* The NFTs sent to the bazaar remain the property of the current collection contract until the "direct" sale stage.

*Note: This is more of a proof of concept. This action would be very interesting, if we already had proof of humanity used in mass, so that the people who buy the NFTs from the bazaar are different from the previous owners, thus increasing the rotativity of the pieces*


### Mint to "chain-friend" or "in-cascade"

The user who mints token #1 automatically mints the seed for the artwork of the user who mints token #2, the user who mints token #2 mints the seed for the artwork of the user who mints token #3, and so on until the user who mints the last token mints the seed for the artwork of the user who minted token #1.

The artworks (visuals) are revealed as soon as the token has an associated seed.

*Note: Looks cool for generative art*


### Community-managed-supply

It allows the community of NFT owners in a collection to propose and vote on whether they want to increase the collection's supply.

Something like:

* The collection's creator or some holder proposes to increase the collection's supply by X
* All the other holders vote for or against the proposal. 1 NFT = 1 Vote
* If the proposal passes the total supply is increased by X
* For a proposal to pass it must have 51% + 1 vote? (maybe)

*Note 1: Looks cool for generative art*

*Note 2: In the case of generative art it is interesting that the creator indicates the " reach" of the algorithm before it becomes repetitive*


### Ethlogy mint

Allows the artist/creator to set up mint flows based on users' onchain signs. The signs project [Ethlogy](https://github.com/math77/ethlogy)


* Drop only for a specific sign
* Sign information used as seed
* Specific artwork for each sign