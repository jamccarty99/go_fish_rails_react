require "rails_helper"

RSpec.describe 'PlayingCard', type: :model do
  let(:card) { PlayingCard.new('Ace', 'Spades') }

  it 'returns rank' do
    expect(card.rank).to eq 'Ace'
  end

  it 'returns suit' do
    expect(card.suit).to eq 'Spades'
  end

  it 'returns value' do
    expect(card.value).to eq 13
  end

  it 'returns a string of first letter of rank and suit' do
    expect(card.toS).to eq 'sa'
  end

  describe 'json conversion' do
    let(:json_data) { card.as_json }
    let(:expanded_json) { PlayingCard.from_json(json_data) }

    it 'returns a json object of card' do
      expect(json_data['rank']).to eq('Ace')
      expect(json_data['suit']).to eq('Spades')
    end

    it 'changes the json card object back into card' do
      expect(expanded_json.rank).to eq('Ace')
      expect(expanded_json.suit).to eq('Spades')
    end
  end
end
