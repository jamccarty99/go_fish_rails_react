class AddFinishedAtToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :finished_at, :datetime
  end
end
