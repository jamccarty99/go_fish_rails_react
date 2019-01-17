import React from 'react';
import ReactDOM from 'react-dom';
import PlayingCard from '../../app/javascript/models/PlayingCard.js'


describe("PlayingCard", () => {
  let rank, suit, card

  beforeEach(() => {
    rank = 'Ace';
    suit = 'Spades';
    card = new PlayingCard(rank, suit);
  });

  describe("rank", () => {
    it("should have a rank", () => {
      expect(card.rank()).toEqual(rank);
    });
  });

  describe("suit", () => {
    it("should have a suit", () => {
      expect(card.suit()).toEqual(suit);
    });
  });

  describe("value", () => {
    it("should have a value", function() {
      expect(card.value("Ace")).toEqual(13);
      expect(card.value("King")).toEqual(12);
    });
  });

  describe("toS", () => {
    it("should convert a card into a string representation", function() {
      expect(card.toS()).toEqual('sa');
      expect(card.toS()).not.toEqual('SA');
    });
  });

  describe("key", () => {
    it("should make a key of rank and suit", () => {
      expect(card.key()).toEqual("Ace-Spades");
    });
  });
});
