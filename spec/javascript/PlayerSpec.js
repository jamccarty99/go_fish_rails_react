import React from 'react';
import ReactDOM from 'react-dom';
import PlayingCard from '../../app/javascript/models/PlayingCard.js'
import Player from '../../app/javascript/models/Player.js'

describe("Player", () => {
  let playerHash, player;

  beforeEach(() => {
    playerHash = {
      name: 'Player 1',
      sets: 2,
      hand: [{rank:'Ace', suit:'Spades'}, {rank:'4', suit:'Clubs'}]
    };
    player = new Player(playerHash);
  });

  describe("name", () => {
    it("should return the players name", () => {
      expect(player.name()).toEqual('Player 1');
    });
  });

  describe("hand", () => {
    it("should return the players hand", () => {
      expect(player.hand()).toEqual([new PlayingCard('Ace', 'Spades'), new PlayingCard('4','Clubs')]);
    });
  });

  describe("sets", () => {
    it("should return the players set count", () => {
      expect(player.sets()).toEqual(2);
    });
  });
});
