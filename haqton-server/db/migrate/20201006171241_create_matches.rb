class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.string :description, null: false
      t.string :creator_name, null: false
      t.string :creator_email, null: false
      t.integer :status, index: true, null: false
      t.integer :topic, index: true, null: false
    end
  end
end
