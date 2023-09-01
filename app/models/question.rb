# frozen_string_literal: true

class Question < ApplicationRecord
  include Commentable

  # тут мы говорим что у Question может быть много answers
  # т.е. создаем отношение один ко многим
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  # строки валидации
  validates :body, presence: true, length: { minimum: 5 }
  validates :title, presence: true, length: { minimum: 3 }

  scope :all_by_tags, lambda { |tag_ids|
    questions = includes(%i[user question_tags tags])
    questions = questions.joins(:tags).where(tags: tag_ids) if tag_ids
    questions.order(created_at: :desc)
  }
end
