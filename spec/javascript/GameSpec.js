import React from 'react';
import ReactDOM from 'react-dom';
import PlayingCard from '../../app/javascript/models/PlayingCard.js'
import CardDeck from '../../app/javascript/models/CardDeck.js'
import Player from '../../app/javascript/models/Player.js'
import Game from '../../app/javascript/models/Game.js'

describe("Game", () => {
  let gameHash, game, card;

  beforeEach(() => {
    gameHash = {
      current_user:{name: 'Player 1', sets: 2, hand: [{rank:'Ace', suit:'Spades'}, {rank:'4', suit:'Clubs'}]},
      opponents:[{ name: 'Player 2', sets: 1, hand: 3 }],
      gameDeck: 38,
      round: 2,
      current_player_name: 'Player 1',
      gameId: 1
    }
    game = new Game(gameHash);
  });

  describe("currentUser", () => {
    it("should return the currentUser", () => {
      expect(game.currentUser().name).toEqual('Player 1');
      expect(game.currentUser()).toEqual({name: 'Player 1', sets: 2, hand: [{rank:'Ace', suit:'Spades'}, {rank:'4', suit:'Clubs'}]});
    });
  });

  describe("opponents", () => {
    it("should return the opponents", () => {
      expect(game.opponents()).toEqual([{ name: 'Player 2', sets: 1, hand: 3 }]);
    });
  });

  describe("gameDeck", () => {
    it("should return the game deck", () => {
      expect(game.gameDeck()).toEqual(38);
    });
  });

  describe("round", () => {
    it("should return the game round", () => {
      expect(game.round()).toEqual(2);
    });
  });

  describe("current_player_name", () => {
    it("should return the name of the current player", () => {
      expect(game.current_player_name()).toEqual('Player 1');
    });
  });

  describe("gameId", () => {
    it("should return the game id", () => {
      expect(game.gameId()).toEqual(1);
    });
  });
});
