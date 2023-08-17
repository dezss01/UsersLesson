class RemoveUserIdFromAnswers < ActiveRecord::Migration[7.0]
  def change
    remove_column :answers, :user_id
  end
end
