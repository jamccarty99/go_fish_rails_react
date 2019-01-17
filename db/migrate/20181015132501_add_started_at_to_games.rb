class AddStartedAtToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :started_at, :datetime
  end
end
