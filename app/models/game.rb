class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users
  # belongs_to :winner, class_name: 'User', optional: true

  scope :pending, -> { where(started_at: nil) }
  scope :in_progress, -> { where.not(started_at: nil).where(finished_at: nil) }
  scope :finished, -> { where.not(started_at: nil).where.not(finished_at: nil).where.not(winner: nil)}
  # serialize :go_fish

  def create_game_if_possible!
    return unless data.nil?

    update!(data: GoFish.new.as_json)
  end

  def create_game_user!(current_user)
    go_fish.add_player(current_user.name)
    users << current_user unless users.include?(current_user)
    update!(data: go_fish.as_json)
  end

  def start!
    return false unless game_size == users.count

    go_fish.start
    update(data: go_fish.as_json, started_at: Time.zone.now)
  end

  def play_round!(player_name, rank)


    go_fish.play_round(player_name, rank)
    winner!
    update!(data: go_fish.as_json)
  end

  def pending?
    game_size != users.size
  end

  def current_player
    go_fish.current_player
  end

  def current_player_name
    go_fish.current_player_name
  end

  def current_user_player(current_user)
    go_fish.players.find{ |player| player.name == current_user.name }
  end

  def opponents(current_user)
    go_fish.players.reject{ |player| player.name == current_user.name }
  end

  def winner!
    return unless go_fish.winner

    update!(finished_at: Time.zone.now, winner: go_fish.winner.name)
  end

  def go_fish
    @go_fish ||= GoFish.from_json(data)
  end
end
