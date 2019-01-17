require_relative 'playing_card'

class CardDeck
  attr_accessor :cards
  RANK = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace]
  SUIT = %w[Clubs Diamonds Hearts Spades]

  def initialize(cards = CardDeck.create_deck)
    @cards = cards
  end

  def self.create_deck
    RANK.flat_map { |rank| SUIT.map { |suit| PlayingCard.new(rank, suit) } }
  end

  def deal
    cards.pop
  end

  def shuffle
    cards.shuffle!
  end

  def cards_left
    cards == [] ? 0 : cards.length
  end

  def empty?
    cards.empty?
  end

  def as_json
    { 'cards' => cards.map(&:as_json) }
  end

  def self.from_json(deck_json)
    CardDeck.new(PlayingCard.collection_from_data(deck_json['cards']))
  end
end
