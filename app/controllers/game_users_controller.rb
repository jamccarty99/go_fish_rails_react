class GameUsersController < ApplicationController
  def create
    game = Game.find params[:game_id]
    game.users << current_user

    if game.start!
      redirect_to game
    else
      redirect_to games_url
    end
  end
end
