require 'rails_helper'
require './app/models/go_fish'
require './app/models/player'
require './app/models/card_deck'
require './app/models/playing_card'

def create_game(player_count)
  game = GoFish.new()
  player_count.times do |number|
    game.add_player("player#{number+1}")
  end
  game
end

RSpec.describe GoFish do
  let(:card) { PlayingCard.new('Ace', "Spades")}
  let(:go_fish) { create_game(2) }
  let(:player1) { go_fish.players[0] }
  let(:player2) { go_fish.players[1] }
  let(:go_fish_json) { go_fish.as_json }

  describe '#initialize' do
    it 'creates player object for each name passed in' do
      expect(player1.name).to eq('player1')
      expect(player1.is_a?(Player)).to be(true)
    end
  end

  describe '#distribute_cards' do
    it 'Should deal 7 cards to each player in a 2 player go_fish game' do
      # debugger;
      go_fish.send(:deck).shuffle
      go_fish.distribute_cards
      # debugger;
      expect(go_fish.players.map(&:hand_count).all?(7)).to be(true)
    end

    it 'should deal 5 cards to each player in a 4 player game' do
      go_fish = create_game(4)
      go_fish.distribute_cards
      expect(go_fish.players.map(&:hand_count).all?(5)).to be(true)
    end
  end

  describe '#current_player' do
    it 'returns the player who has the current turn' do
      expect(go_fish.current_player.name).to eq 'player1'
      go_fish.next_player;
      expect(go_fish.current_player.name).to eq 'player2'
    end

    it 'returns a default value if there are no players yet' do
      empty_game = GoFish.new()
      expect(empty_game.current_player).to eq []
    end
  end

  describe '#current_player' do
    it 'returns the name of the player who has the current turn' do
      expect(go_fish.current_player_name).to eq 'player1'
      go_fish.next_player;
      expect(go_fish.current_player_name).to eq 'player2'
    end

    it 'returns a default value if there is no current_player' do
      empty_game = GoFish.new()
      expect(empty_game.current_player_name).to eq 'No Players'
      empty_game.add_player('Player 1');
      expect(empty_game.current_player_name).to eq 'Player 1'
    end
  end

  describe '#next_player' do
    it 'changes the current player to the next player' do
      go_fish.next_player
      expect(go_fish.current_player.name).to eq 'player2'
      go_fish.next_player
      expect(go_fish.current_player.name).to eq 'player1'
    end

    it 'tells next player to go fish if their hand is empty' do
      go_fish.send(:go_fishing)
      expect(go_fish.current_player.name).to eq('player1')
    end
  end

  describe '#card_transfer' do
    it("transfers card(s) from requested to current_player") do
      go_fish.start
      go_fish.send(:card_transfer, player2, player2.send(:hand)[0].rank)
      expect(go_fish.current_player.hand_count).to_not be(7)
    end
  end

  describe '#go_fishing' do
    before do
      go_fish.start
      go_fish.send(:go_fishing)
    end

    it('takes a card from the deck') do
      expect(player1.hand_count).to be(8)
      expect{ go_fish.send(:go_fishing) }.to change { player2.hand_count }.by 1
    end

    it('goes to the next round after fishing') do
      expect(go_fish.current_player.name).to eq('player2')
    end

    it('skips to next player without adding cards if deck is empty') do
      emptyDeck = GoFish.new([], [])
      emptyDeck.add_player('player1')
      emptyDeck.add_player('player2')
      emptyDeck.players[0].hand.push(card)
      emptyDeck.players[1].hand.push(card)
      expect(emptyDeck.cards_left).to be(0)
      emptyDeck.send(:go_fishing)
      expect(player2.hand_count).to be(7)
    end
  end

  describe('#find_player') do
    it('correctly finds the player') do
      result = go_fish.find_player('player1')
      expect(result.name).to eq('player1')
    end
  end

  describe('#play_round') do
    before do
      go_fish.start
    end

    it('current_user can play a round with successful fish') do
      expect(player1.hand_count).to be(7)
      expect(player2.hand_count).to be(7)
      go_fish.play_round(player2.name, player2.send(:hand)[0].rank)
      expect(player1.hand_count).to_not be(7)
      expect(player2.hand_count).to_not be(7)
    end

    it 'changes the number of cards the current player has' do
      expect{ go_fish.play_round('player2', 'Ace') }.to change(player1, :hand_count)
    end
  end

  describe 'highest_set_count' do
    it('finds the highest set count in the game') do
      player1.add_cards([card,card,card,card])
      player1.check_for_sets
      expect(go_fish.send(:highest_set_count)).to be(1)
    end
  end

  describe 'highest_set_count_players' do
    it('finds the players with the highest set count in the game') do
      player1.add_cards([card,card,card,card])
      player2.add_cards([card,card,card,card])
      go_fish.players.map(&:check_for_sets)
      result = go_fish.send(:highest_set_count_players)
      expect(result.count).to be(2)
      expect(result.all?(Player)).to be(true)
      expect(result.all?{|player| player.sets_count == 1}).to be(true)
    end
  end

  describe('#draw?') do
    it('return true if draw')do
      player1.add_cards([card,card,card,card])
      player2.add_cards([card,card,card,card])
      go_fish.players.map(&:check_for_sets)
      expect(go_fish.send(:draw?)).to be(true)
    end

    it('return false if only one player wins')do
      player1.add_cards([card,card,card,card])
      player1.check_for_sets
      expect(go_fish.send(:draw?)).to be(false)
    end
  end

  describe('#highest_set_value') do
    before do
      player1.send(:make_a_set, '8')
      player2.send(:make_a_set, '9')
    end

    it('find the set value of the highest set count')do
      expect(go_fish.send(:highest_set_value)).to be(8)
    end
  end

  describe('#double_draw?') do
    before do
      player1.send(:make_a_set, '9')
      player2.send(:make_a_set, '9')
    end

    it('returns true if double draw (same set count,same set value)')do
      expect(go_fish.send(:double_draw?)).to be(true)
    end
  end

  describe('#tie_breaker_winner') do
    let(:go_fish) { create_game(3) }
    let(:player1) { go_fish.players[0]}
    let(:player2) { go_fish.players[1]}
    let(:player3) { go_fish.players[2]}

    before do
      player1.send(:make_a_set, 'Queen')
      player1.send(:make_a_set, '4')
      player2.send(:make_a_set, 'King')
      player2.send(:make_a_set, '3')
      player3.send(:make_a_set, 'Ace')
      player3.send(:make_a_set, '2')
    end

    it('compare players and see who has the highest value points')do
      expect(go_fish.send(:tie_breaker_winner)).to be(player3)
    end

    it 'returns the player with the highest sets value' do
      player1.send(:make_a_set, '5')
      player2.send(:make_a_set, '6')
      expect(go_fish.send(:tie_breaker_winner)).to be(player2)
    end
  end

  describe '#game_over?' do
    it 'returns false if there are sets left to be made' do
      player1.send(:make_a_set, 'Ace')
      expect(go_fish.send(:game_over?)).to be(false)
    end

    it 'returns true if all sets have been made' do
      expect(go_fish.send(:game_over?)).to be(false)
      13.times { player1.send(:make_a_set, 'Ace') }
      expect(go_fish.send(:game_over?)).to be(true)
    end
  end

  describe '#winner' do
    let(:go_fish) { create_game(3) }
    let(:player1) { go_fish.players[0]}
    let(:player2) { go_fish.players[1]}
    let(:player3) { go_fish.players[2]}

    it 'returns the winner of the game' do
      13.times { player1.send(:make_a_set, 'Ace') }
      expect(go_fish.send(:game_over?)).to be(true)
      expect(go_fish.winner).to be(player1)
    end

    it 'returns the winner, who has the most of 13 sets' do
      expect(go_fish.winner).to be_nil
      6.times { player1.send(:make_a_set, 'King') }
      6.times { player2.send(:make_a_set, 'Ace') }
      1.times { player3.send(:make_a_set, 'Jack') }
      expect(go_fish.winner).to be player2
      expect(player2.won?).to be true
      expect(player1.won?).to be false
    end
  end

  describe '#as_json' do
    it('converts data into hash') do
      expect(go_fish_json['players'].is_a?(Array)).to be true
      # expect(go_fish_json['deck']).to eq()
      expect(go_fish_json['round']).to eq(go_fish.round)
    end

    it("json's players array have player data") do
      player1.add_cards(card)
      expect(go_fish_json['players'][0]['hand'][0]['rank']).to eq(card.rank)
    end
  end

  describe '#from_json' do
    let(:inflated_go_fish) { GoFish.from_json(go_fish_json) }

    it('inflated go_fish has the correct attribute and methods') do
      expect(inflated_go_fish.players[0]).to be_an_instance_of(Player)
      expect(inflated_go_fish.send(:deck)).to be_an_instance_of(CardDeck)
      expect(inflated_go_fish.round).to eq(go_fish.round)
    end

    it('inflated go_fish players can have cards with playing card class') do
      player1.add_cards(card)
      expect(inflated_go_fish.players.empty?).to be false
      expect(inflated_go_fish.players[0].send(:hand)[0].rank).to eq('Ace')
      expect(inflated_go_fish.players[0].send(:hand)[0]).to be_an_instance_of(PlayingCard)
    end
  end
end
