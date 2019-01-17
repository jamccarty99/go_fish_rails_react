export default class PlayingCard {
  constructor(rank, suit) {
    this._rank = rank;
    this._suit = suit;
  }

  static rankValues() {return { '2': 1, '3': 2, '4': 3, '5': 4, '6':5, '7':6, '8': 7, '9': 8, '10': 9, 'Jack': 10, 'Queen': 11, 'King': 12, 'Ace': 13 }};

  rank() {
    return this._rank
  }

  suit() {
    return this._suit
  }

  value(rank) {
    return PlayingCard.rankValues()[rank];
  }

  toS() {
    return (this.suit()[0].toLowerCase() + this.rank()[0].toLowerCase())
  }

  key() {
    return `${this.rank()}-${this.suit()}`
  }
}
