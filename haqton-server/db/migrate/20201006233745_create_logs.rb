class CreateLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :logs do |t|
      t.string :user, null: false
      t.string :endpoint, null: false
      t.datetime :datetime, null: false
    end
  end
end
