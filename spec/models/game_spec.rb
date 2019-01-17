require "rails_helper"

RSpec.describe Game, type: :model do
  describe '.pending' do
    it 'returns games not yet started' do
      done_game = create(:game, :finished)
      in_progress = create(:game, :started)
      pending = create(:game)

      expect(Game.pending).to eq [ pending ]
    end
  end

  describe '.in_progress' do
    it 'returns games still in progress' do
      done_game = create(:game, :finished)
      in_progress = create(:game, :started)
      pending = create(:game)

      expect(Game.in_progress).to eq [ in_progress ]
    end
  end

  describe '.finished' do
    it 'returns games that are finished' do
      done_game = create(:game, :finished, :winner)
      in_progress = create(:game, :started)
      pending = create(:game)

      expect(Game.finished).to eq [ done_game ]
    end
  end

  describe '.start!' do
    it 'returns games still in progress' do
      pending = create(:game)
      pending.create_game_if_possible!
      pending.create_game_user!(create(:user))
      pending.create_game_user!(create(:user))
      expect(Game.in_progress.count).to eq 0
      pending.start!
      expect(Game.in_progress.count).to eq 1
    end
  end
end
