class CreateMatchPlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :match_players do |t|
      t.string :player_name
      t.string :player_email
      t.boolean :approved
      t.integer :score
      t.references :match, index: true, foreign_key: true
    end
  end
end
