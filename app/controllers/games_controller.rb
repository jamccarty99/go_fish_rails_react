

class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  @@pusher_client = Pusher::Client.new(
    app_id: '620858',
    key: '03a04c4a34a3b4645a8b',
    secret: '22817bb1a51e9cd06b2e',
    cluster: 'us2',
    encrypted: true
  )


  def show
    @found_game = Game.find(params[:id])
    @game = game_presenter(@found_game, current_user)
    respond_to do |format|
      format.html
      format.json { render json: @game.state_for }
    end
  end

  def index
  end

  def create
    game = Game.find_or_initialize_by(game_size: params[:game_size].to_i)
    game.create_game_if_possible!
    game.create_game_user!(current_user)
    game.start!
    redirect_to game_path(game)
  end

  def update
    @found_game = Game.find(params[:id])
    @found_game.play_round!(params[:requestedPlayer], params[:requestedRank])
    @game = game_presenter(@found_game, current_user)
    refresh(params[:id])
    render json: @game.state_for
  end

private

  def game_presenter(game, current_user)
    GamePresenter.new(game, current_user)
  end

  def reload(gameId)
    @@pusher_client.trigger('go_fish', 'reload', {:gameId => gameId})
  end

  def refresh(gameId)
    @@pusher_client.trigger('go_fish', 'updateGame', {:gameId => gameId})
  end
end
