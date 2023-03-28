# Weird Actions

An attempt to build a set of action contracts for NFTs. Each action is composed of contracts that are deployed by artists and creators activating self-sovereignty. The ultimate goal is to have more tools for creators to experiment beyond the current default mint().

## Actions

### MergeNFT

It allows artists and creators to implement a mint new NFT contract based on the merger of another NFTs.

The creator must set how many NFTs need to be merged by the user in order to receive a new NFT, which collection the NFTs that must be merged come from and what happens to the NFTs after they are merged.

Among the possibilities of what happens to NFTs that have been merged are:
* The NFTs are burned
* NFTs are locked into the merger contract


### Friend-invite mint

It allows artists and creators to implement a mint-invite based minting process.

The process works this way:

* The token #1 of the collection is minted by the artist/creator.
* When minting token #1 the artist/creator indicates the address of the next user who can mint token #2
* When the user mints token #2 it indicates the address of the user who can mint token #3
* The process continues until the maximum supply of the collection is reached.


### Friend-payed-invite mint

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


### Dynamic supply

#### Community-managed-supply

It allows the community of NFT owners in a collection to propose and vote on whether they want to increase the collection's supply.

Something like:

* The collection's creator or some holder proposes to increase the collection's supply by X
* All the other holders vote for or against the proposal. 1 NFT = 1 Vote
* If the proposal passes the total supply is increased by X
* For a proposal to pass it must have 51% + 1 vote? (maybe)

*Note 1: Looks cool for generative art*

*Note 2: In the case of generative art it is interesting that the creator indicates the " reach" of the algorithm before it becomes repetitive*


#### Supply increase over time

It allows artists/creators to create collections that start with a certain supply, and this supply increases at a certain rate over a certain period of time until it reaches a target ceiling. 

E.g.: Collection starts with 1000 tokens available and every 9 months 500 new tokens will be available until the maximum supply of 5000 tokens is reached.


*Note: Maybe this is better as a module or extension that is pluggable into other weird actions*

#### Mint token and increase supply

When you mint a token that token increases the total available supply by a new slot of X tokens. This new supply is of tokens that are children of the "originals".

The contract creator defines:
- How many new supply slots will be added whenever a new token is minted
- The depth of the increase (if child tokens also add new slots)

Send the tokenId and its "depth" to the rendering function.

*Note: Can be interesting for generative art or collections that want to add some kind of "hierarchy".*


### Netlogy mint

Allows the artist/creator to set up mint flows based on users' onchain signs. The signs project [Netlogy](https://github.com/math77/netlogy)


* Drop only for a specific sign
* Sign information used as seed
* Specific artwork for each sign


### Rule-based mint

Allows the creation of rule-based mint flows that use the data from the: [Weird actions stuff storage](https://github.com/math77/weird-actions-stuff-storage)

Rules examples:

* Mint only for those who have spent X ETH on mints in the Y collection
* Mint only for those who have spent X ETH on mints in total in all collections
* Mint only for those who have more than 10 invitations in a given collection that uses the "friend-invite mint" contract
* Many more...

*Note: The collections are the ones that use any of the weird-actions contracts*


### Playful little "commands"

#### Shuffle all tokens

Allows after the mint period is over the contract creator to call a function that will randomly shuffle the list of tokens and their owners.


#### Burn a few and let re-mint

It allows the contract creator to call a function shortly after the mint period is over, which will randomly burn some tokens and let the owners of those tokens re-mint new different ones.


#### "Share" a token

Allows the owner of a media to share it with someone else, as a gift!

Sharing media means creating a copy of NFT and sending it to other users' wallets. When an NFT is shared in the metadata it is indicated that it has been shared.

```
{
 "title": "...",
 "image": "...",
 "description": "...",
 "shared": true,
}

```
