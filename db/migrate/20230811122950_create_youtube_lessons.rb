# frozen_string_literal: true

class CreateYoutubeLessons < ActiveRecord::Migration[7.0]
  def change
    create_table :youtube_lessons do |t|
      t.integer :number
      t.string :name
      t.string :link
      t.string :description

      t.timestamps
    end
  end
end
