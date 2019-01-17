require "rails_helper"
require "pry"

RSpec.describe GamePresenter, type: :model do
  let(:test_fish_game) { Game.new({game_size: 2}) }
  let(:presenter) { GamePresenter.new(test_fish_game, user1) }
  let(:user1) { User.new({name: 'Player 1', password: 'password', password_confirmation: 'password'}) }
  let(:user2) { User.new({name: 'Player 2', password: 'password', password_confirmation: 'password'}) }

  before do
    test_fish_game.create_game_if_possible!
    test_fish_game.create_game_user!(user1)
    test_fish_game.create_game_user!(user2)
    test_fish_game.start!
  end

  describe 'opponent_data' do
    it 'returns an array of opponents without current_user' do
      presenter = GamePresenter.new(test_fish_game, user1)
      opponent_data = presenter.opponent_data["opponents"]
      expect(opponent_data.length).to eq 1
      expect(opponent_data.length).not_to eq 2
    end

    it 'returns an opponents name' do
      presenter = GamePresenter.new(test_fish_game, user1)
      opponent_data = presenter.opponent_data["opponents"]
      expect(opponent_data[0]["name"]).to eq 'Player 2'
    end

    it 'returns an opponents set count' do
      presenter = GamePresenter.new(test_fish_game, user1)
      opponent_data = presenter.opponent_data["opponents"]
      expect(opponent_data[0]["hand"]).to eq 7
    end

    it 'returns an opponents hand count' do
      presenter = GamePresenter.new(test_fish_game, user1)
      opponent_data = presenter.opponent_data["opponents"]
      expect(opponent_data[0]["sets"]).to eq 0
    end
  end

  describe 'current_user_data' do
    it 'returns an object of the current_user information' do
      presenter = GamePresenter.new(test_fish_game, user1)
      current_data = presenter.current_user_data
      expect(current_data).to be_an_instance_of Hash
      # TODO replace line above with expect actual data
    end

    it 'returns current_user name' do
      presenter = GamePresenter.new(test_fish_game, user1)
      current_data = presenter.current_user_data
      expect(current_data["name"]).to eq 'Player 1'
    end

    it 'returns current_user set count' do
      presenter = GamePresenter.new(test_fish_game, user1)
      current_data = presenter.current_user_data
      expect(current_data["sets"]).to eq 0
    end

    it 'returns current_user hand' do
      presenter = GamePresenter.new(test_fish_game, user1)
      current_data = presenter.current_user_data
      expect(current_data["hand"]).to be_an_instance_of Array
      # TODO replace line above with expect actual data
    end
  end

  describe 'state_for' do
    it 'returns an object with the game state' do
      presenter = GamePresenter.new(test_fish_game, user1)
      state_data = presenter.state_for
      expect(state_data).to be_an_instance_of Hash
      # TODO replace line above with expect actual data
    end

    it 'returns a current_user object' do
      presenter = GamePresenter.new(test_fish_game, user1)
      state_data = presenter.state_for
      expect(state_data["current_user"]["name"]).to eq "Player 1"
    end

    it 'returns an opponents object' do
      presenter = GamePresenter.new(test_fish_game, user1)
      state_data = presenter.state_for
      expect(state_data["opponents"][0]["name"]).to eq "Player 2"
    end

    it 'returns the deck count' do
      presenter = GamePresenter.new(test_fish_game, user1)
      state_data = presenter.state_for
      expect(state_data["gameDeck"]).to eq 38
    end

    it 'returns the round' do
      presenter = GamePresenter.new(test_fish_game, user1)
      state_data = presenter.state_for
      expect(state_data["round"]).to eq 0
    end

    it 'returns the current_player' do
      presenter = GamePresenter.new(test_fish_game, user1)
      state_data = presenter.state_for
      expect(state_data["current_player_name"]).to eq (presenter.current_player_name)
    end

    it 'returns the game id' do
      presenter = GamePresenter.new(test_fish_game, user1)
      state_data = presenter.state_for
      expect(state_data["gameId"]).to eq (presenter.gameId)
    end

    it 'returns the game winner' do
      done_game = create(:game, :finished, :winner)
      done_game.create_game_if_possible!
      done_game.create_game_user!(user1)
      done_game.create_game_user!(user2)
      done_game.start!
      presenter = GamePresenter.new(done_game, user1)
      state_data = presenter.state_for
      expect(state_data["gameWinner"]).to eq ('Player 1')
    end
  end
end
