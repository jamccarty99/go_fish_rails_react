class GamePresenter
  def initialize(game, current_user)
    @game = game
    @current_user = current_user
  end

  def gameId
    @game.id
  end

  def current_player_name
    @game.current_player == [] ? 'No Players' : @game.current_player.name
  end

  def opponents
    @game.opponents(@current_user)
  end

  def state_for
      {
        "current_user" => current_user_data,
        "opponents" => opponent_data["opponents"],
        "gameDeck" => @game.go_fish.cards_left,
        "round" => @game.go_fish.round,
        "current_player_name" => current_player_name,
        "gameId" => @game.id,
        "gameWinner" => @game.winner
      }
  end

  def current_user_data
    current_user = @game.current_user_player(@current_user)
    {
      "name" => current_user.name,
      "sets" => current_user.sets_count, #TODO: make this just sets and display them, not just count
      "hand" => current_user.hand,
    }
  end

  def opponent_data
    {
      "opponents" => opponents.map do |opponent|
        {
          "name" => opponent.name,
          "sets" => opponent.sets_count, #TODO: make this just sets and display them, not just count
          "hand" => opponent.hand_count,
        }
      end
    }
  end
end
