class PlayingCard
  attr_reader :rank, :suit

  VALUES = {
    '2' => 1,
    '3' => 2,
    '4' => 3,
    '5' => 4,
    '6' => 5,
    '7' => 6,
    '8' => 7,
    '9' => 8,
    '10' => 9,
    'Jack' => 10,
    'Queen' => 11,
    'King' => 12,
    'Ace' => 13
  }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def toS
    "#{suit[0].downcase}#{rank[0].downcase}"
  end

  def self.value(rank)
    VALUES[rank]
  end

  def value
    VALUES[rank]
  end

  def as_json(*)
    {
      'rank' => rank,
      'suit' => suit
    }
  end

  def self.from_json(card_json)
    PlayingCard.new(card_json['rank'], card_json['suit'])
  end

  def self.collection_from_data(data)
    data.map{ |card_data| PlayingCard.from_json(card_data)}
  end
end
