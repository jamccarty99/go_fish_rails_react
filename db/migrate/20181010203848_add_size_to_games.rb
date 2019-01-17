class AddSizeToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :game_size, :integer
  end
end
