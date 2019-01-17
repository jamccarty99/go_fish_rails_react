import PlayingCard from './PlayingCard.js'

export default class CardDeck {
  constructor(deckCount) {
    this._gameDeck = deckCount;
  }

  gameDeck() {
    return this._gameDeck
  }
}
