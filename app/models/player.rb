class Player
  attr_reader :name, :sets
  attr_accessor :hand

  def initialize(name, hand = [], sets = [])
    @name = name
    @hand = hand
    @sets = sets
    @win = false
  end

  def hand_count
    hand.count
  end

  def sets_count
    sets.count
  end

  def add_cards(cards)
    cards.is_a?(Array) ? hand.concat(cards) : hand.push(cards)
    check_for_sets
    hand
  end

  def check_for_sets
    hand.each{ |card| (make_a_set(card.rank) if (rank_count(card.rank) == 4)) }
  end

  def has_any?(rank)
    ranks_in_hand.any?(rank)
  end

  def give_cards(rank)
    gift = hand.select{ |card| card.rank == rank }
    hand.reject!{ |card| card.rank == rank }
    gift
  end

  def empty?
    hand.empty?
  end

  def sets_value
    total_value = sets.map{ |rank| PlayingCard.value(rank) }.reduce(:+)
  end

  def highest_value
    value_array = sets.map{|rank| PlayingCard.value(rank)}
    value_array.max
  end

  def as_json(*)
    {
      'name' => name,
      'hand' => hand.map(&:as_json),
      'sets' => sets
    }
  end

  def self.from_json(player_json)
    Player.new(
      player_json['name'],
      PlayingCard.collection_from_data(player_json['hand']),
      player_json['sets']
    )
  end

  def self.collection_from_data(data)
    data.map{ |player_data| Player.from_json(player_data)}
  end

  def win
    @win = true
    return self
  end

  def won?
    return @win
  end

  private

  def ranks_in_hand
    hand.map(&:rank).uniq
  end

  def rank_count(passed_rank)
    hand.each_with_object(Hash.new(0)) { |card,counts| counts[card.rank] += 1 }.fetch(passed_rank, 0)
  end

  def make_a_set(passed_rank)
    sets.push(passed_rank)
    hand.reject!{ |card| card.rank == passed_rank }
  end

  def sort_cards
    hand.sort! { |a, b| a.value <=> b.value }
  end


end
