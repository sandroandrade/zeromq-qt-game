class CreateQuestionOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :question_options do |t|
      t.string :description
      t.references :question, index: true, foreign_key: true
    end
  end
end
