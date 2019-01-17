class GoFish
  attr_reader :players, :round

  def initialize(players = [], deck = CardDeck.new, round = 0)
    @players = players
    @deck = deck
    @round = round
  end

  def add_player(name)
    players.push(Player.new(name))
  end

  def fill_game_with_bots(game_size)
    number_of_bots = game_size - players.count
 # TODO wait till later to fill in
  end

  def start
    deck.shuffle
    distribute_cards
  end

  def current_player
    players ==  [] ? [] : players[round % players.count]
  end

  def current_player_name
    current_player == [] ? 'No Players' : current_player.name
  end

  def next_player
    self.round = round + 1
    go_fishing if current_player.empty?
  end

  def find_player(player_name)
    players.find{ |player| player.name == player_name }
  end

  def play_round(player_name, rank)
    return if winner
    # debugger;
    player = find_player(player_name)
    player.has_any?(rank) ? card_transfer(player, rank) : go_fishing
    go_fishing if current_player.empty?
  end

  def round
    @round
  end

  def distribute_cards
    starting_hand = players.count > 3 ? 5 : 7
    starting_hand.times do
      players.each{ |player| player.add_cards(deck.deal) }
      # debugger;
    end
  end

  def cards_left
    (deck == []) ? 0 : deck.cards_left
  end

  def winner
    return unless game_over?

    draw? ? tie_breaker_winner.win : players.max_by(&:sets_count).win
  end

  def as_json
    {
      'players' => players.map(&:as_json),
      'deck' => deck.as_json,
      'round' => round,
      # 'current_player_name' => current_player_name,
    }
  end

  def self.from_json(go_fish_json)
    GoFish.new(
      Player.collection_from_data(go_fish_json['players']),
      CardDeck.from_json(go_fish_json['deck']),
      go_fish_json['round'],
      # go_fish_json['current_player_name'],
    )
  end

private

attr_writer :players, :round
attr_reader :deck

  def game_over?
    total_sets = players.map(&:sets_count).reduce(:+)
    total_sets == 13
  end

  def card_transfer(player, rank)
    current_player.add_cards(player.give_cards(rank))
  end

  def go_fishing
    return if winner

    current_player.add_cards(deck.deal) unless deck.empty?
    next_player
  end

  def highest_set_count
    players.max_by(&:sets_count).sets_count
  end

  def highest_set_count_players
    players.select{ |player| player.sets_count == highest_set_count }
  end

  def draw?
    highest_set_count_players.count > 1
  end

  def highest_set_value
    highest_set_count_players.max_by(&:sets_value).sets_value
  end

  def double_draw?
    values = players.map(&:sets_value)
    values.count{ |value| value == highest_set_value } > 1
  end

  def tie_breaker_winner
    if double_draw?
      highest_set_count_players.max_by(&:highest_value)
    else
      highest_set_count_players.max_by(&:sets_value)
    end
  end
end
