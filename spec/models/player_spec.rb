require "spec_helper"
require "./app/models/player"
require "./app/models/playing_card"
require "pry"

RSpec.describe 'Player', type: :model do
  let(:joey) { Player.new('Joey') }
  let(:joey_json) { joey.as_json }
  let(:inflated_joey) { Player.from_json(joey_json) }
  let(:card) { PlayingCard.new('Queen', 'Spades') }
  let(:card2) { PlayingCard.new('4', 'Hearts') }
  let(:set) {[
    PlayingCard.new('Queen', 'Spades'),
    PlayingCard.new('Queen', 'Clubs'),
    PlayingCard.new('Queen', 'Hearts'),
    PlayingCard.new('Queen', 'Diamonds')
  ]}

  describe '#initialize' do
    it 'should have correct attributes' do
      expect(joey.name).to eq 'Joey'
      expect(joey.send(:hand).is_a?(Array)).to be true
      expect(joey.send(:sets).is_a?(Array)).to be true
    end
  end

  describe '#add_cards' do
    it 'should be able to add a single card' do
      joey.add_cards(card)
      expect(joey.hand_count).to be(1)
    end

    it 'should be able to add an array of cards' do
      joey.add_cards([card, card])
      expect(joey.hand_count).to be(2)
    end
  end

  describe '#ranks_in_hand' do
    it ('should only show what ranks in hand') do
      joey.add_cards([card, card2, card])
      # binding.pry
      expect(joey.send(:ranks_in_hand)[0]).to eq(card.rank)
      expect(joey.send(:ranks_in_hand)[1]).to eq(card2.rank)
      expect(joey.send(:ranks_in_hand)[2]).to eq(nil)
    end
  end

  describe '#rank_count' do
    it('should be able to count how many cards of the same rank') do
      joey.add_cards([card, card])
      expect(joey.send(:rank_count, card.rank)).to eq(2)
      expect(joey.send(:rank_count, card2.rank)).to eq(0)
    end
  end

  describe '#make_a_set' do
    it('should make a set when the player has a set') do
      expect(joey.sets_count).to be(0)
      joey.add_cards(set)
      expect(joey.sets_count).to be(1)
    end

    it('should remove cards in hand after making a set') do
      joey.hand.push(set).flatten!
      joey.send(:make_a_set, 'Queen')
      expect(joey.hand_count).to be(0)
    end
  end

  describe '#check_for_sets' do
    it('check if there are any sets in hand') do
      expect(joey.sets_count).to be(0)
      joey.add_cards(set)
      expect(joey.sets_count).to be(1)
      expect(joey.hand_count).to be(0)
      expect(joey.sets).to eq(['Queen'])
    end
  end

  describe '#has_any?' do
    it('checks if player have the rank requested') do
      joey.add_cards(card)
      expect(joey.has_any?(card.rank)).to be(true)
      expect(joey.has_any?(card2.rank)).to be (false)
    end
  end

  describe '#sets_value' do
    it('returns the total value of all the sets for the player') do
      joey.hand.push(set).flatten!
      joey.send(:make_a_set, 'Queen')
      joey.hand.push(set).flatten!
      joey.send(:make_a_set, 'Queen')
      expect(joey.sets_value).to be(22)
    end
  end

  describe '#highest_value' do
    it('returns the value of the highest ranked set') do
      joey.hand.push(set).flatten!
      joey.send(:make_a_set, 'Queen')
      joey.hand.push(set).flatten!
      joey.send(:make_a_set, 'King')
      expect(joey.highest_value).to be(12)
    end
  end

  describe('#give_cards') do
    it 'returns an array of card(s)' do
      joey.add_cards(card)
      result = joey.give_cards(card.rank)
      expect(result.is_a?(Array)).to be(true)
    end

    it 'returns the requested card(s)' do
      joey.add_cards([card,card2])
      result = joey.give_cards(card.rank)
      expect(result[0].rank).to eq(card.rank)
    end

    it 'removes the requested card(s) from hand' do
      joey.add_cards([card,card2])
      joey.give_cards(card.rank)
      expect(joey.hand_count).to eq(1)
      expect(joey.hand[0].rank).to eq(card2.rank)
    end
  end

  describe('#sort_cards') do
    it('sorts cards in order of rank')do
      joey.add_cards([card,card2])
      joey.send(:sort_cards)
      expect(joey.send(:hand)[0].rank).to eq(card2.rank)
    end
  end

  describe('#empty?') do
    it'return true if hand is empty' do
      expect(joey.empty?).to be(true)
      joey.hand.push(set).flatten!
      expect(joey.empty?).to be(false)
    end
  end

  describe('#win') do
    it'sets win to true and returns the winning player object' do
      expect(joey.won?).to be(false)
      expect(joey.win).to be joey
      expect(joey.won?).to be(true)
    end
  end

  describe('#won?') do
    it'return true if win is true, else false' do
      expect(joey.won?).to be(false)
      joey.win
      expect(joey.won?).to be(true)
    end
  end

  describe '#as_json' do
    it('converts data into hash') do
      expect(joey_json['name']).to eq(joey.name)
      expect(joey_json['hand'].is_a?(Array)).to be true
    end

    it("json's hand array have card data") do
      joey.add_cards(card)
      expect(joey_json['hand'][0]['rank']).to eq(card.rank)
    end
  end

  describe '#from_json' do
    it('inflated player have the correct attribute and methods') do
      expect(inflated_joey.name).to eq(joey.name)
    end

    it('inflated player can have cards with playing card class') do
      joey.add_cards(card)
      expect(inflated_joey.empty?).to be false
      expect(inflated_joey.has_any?(card.rank)).to be true
      expect(inflated_joey.send(:hand)[0]).to be_an_instance_of(PlayingCard)
    end
  end
end
