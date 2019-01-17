import React from 'react';
import ReactDOM from 'react-dom';
import CardDeck from '../../app/javascript/models/CardDeck.js'

describe("CardDeck", () => {
  let deck = new CardDeck(38)

  describe("gameDeck", () => {
    it("should return the number of cards in the deck", () => {
      expect(deck.gameDeck()).toEqual(38);
    });
  });
});
