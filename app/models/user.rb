class User < ApplicationRecord
  has_many :game_users
  has_many :games, through: :game_users
  # has_many :won_games, class_name: 'Game', foreign_key: :winner_id

  validates :name,  presence: true, length: { maximum: 50 }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }#, confirmation: true
  # validates :password_confirmation, presence: true

  # def won_games
  #   games.where(winner: self)
  # end

  # def winning_percentage
  #   return 0 unless games.any?
  #   won_games.count / games.count.to_f
  # end
  #
  # def winning_percentage_string
  #   "#{(winning_percentage * 100).round}%"
  # end
end
