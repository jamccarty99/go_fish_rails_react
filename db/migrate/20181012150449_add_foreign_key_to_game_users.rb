class AddForeignKeyToGameUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :game_users, :game, foreign_key: true
    add_reference :game_users, :user, foreign_key: true
  end
end
