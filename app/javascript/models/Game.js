import Player from './Player.js'
import CardDeck from './CardDeck.js'
import PlayingCard from './PlayingCard.js'

export default class Game {
  constructor(gameHash) {
    this._currentUser = gameHash.current_user
    this._opponents = gameHash.opponents
    this._gameDeck = gameHash.gameDeck
    this._round = gameHash.round
    this._currentPlayerName = gameHash.current_player_name
    this._gameId = gameHash.gameId
  }

  currentUser() {
    return this._currentUser
  }

  opponents() {
    return this._opponents
  }

  gameDeck() {
    return this._gameDeck
  }

  round() {
    return this._round
  }

  current_player_name() {
    return this._currentPlayerName
  }

  gameId() {
    return this._gameId
  }
}
