require "rails_helper"

RSpec.describe 'CardDeck', type: :model do
  let(:deck) { CardDeck.new(deck_of_2) }
  let(:deck_of_2) { [PlayingCard.new('Queen', 'Spades'), PlayingCard.new('4', 'Spades')] }

  describe 'create_deck' do
    it 'Should have 52 cards when started' do
      test = CardDeck.new
      expect(test.cards_left).to eq 52
    end
  end

  describe 'cards_left' do
    it 'Should return how many cards are left in the deck' do
      expect(deck.cards_left).to eq 2
    end
  end

  describe 'deal' do
    it 'Should take a card from the deck' do
      card = deck.deal
      expect(card.rank).to match(/4/)
      expect(card.suit).to match(/Spades/)
    end
  end

  describe 'shuffle' do
    it 'shuffles the cards' do
      deck1 = CardDeck.new
      deck2 = CardDeck.new
      expect(deck1.deal.toS).to eq deck2.deal.toS
      deck1.shuffle
      expect(deck1.deal.toS).not_to eq deck2.deal.toS
    end
  end

  describe 'json conversion' do
    let(:deck) { CardDeck.new }
    let(:deck_json) { deck.as_json }
    let(:expanded_deck) { CardDeck.from_json(deck_json) }

    it 'returns a json object of deck' do
      expect(deck_json).to be_a Hash
    end

    it 'changes the json deck object back into a deck' do
      expect(expanded_deck).to be_an_instance_of CardDeck
    end
  end
end
