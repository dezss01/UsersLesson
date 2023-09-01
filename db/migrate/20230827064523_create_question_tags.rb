 class CreateQuestionTags < ActiveRecord::Migration[7.0]
  def change
    create_table :question_tags do |t|
      t.belongs_to :question, null: false, foreign_key: true
      t.belongs_to :tag, null: false, foreign_key: true

      t.timestamps
    end

    # эта строка позволит не появиться двум записям с одинаковыми question_id и tag_id
    # потому что нет смысла добавлять к одному вопросу кучу одинаковых тегов
    add_index :question_tags, %i[question_id tag_id], unique: true
  end
end
