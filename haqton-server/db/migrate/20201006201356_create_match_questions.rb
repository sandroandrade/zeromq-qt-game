class CreateMatchQuestions < ActiveRecord::Migration[6.0]
  def change
    create_join_table :matches, :questions, table_name: :matches_questions
  end
end
