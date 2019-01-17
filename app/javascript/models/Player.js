import PlayingCard from './PlayingCard.js'
import CardDeck from './CardDeck.js'

export default class Player {
  constructor(playerHash) {
    this._name = playerHash.name
    this._hand = playerHash.hand.map(({rank, suit}) => {
      return new PlayingCard(rank, suit)
    })
    this._sets = playerHash.sets
  }

  name() {
    return this._name
  }

  hand() {
    return this._hand
  }

  sets() {
    return this._sets
  }
}
