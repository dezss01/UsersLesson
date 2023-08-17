# frozen_string_literal: true
class Question < ApplicationRecord
  # тут мы говорим что у Question может быть много answers
  # т.е. создаем отношение один ко многим
  has_many :answers, dependent: :destroy
  belongs_to :user

  # строки валидации
  validates :body, presence: true, length: { minimum: 5 }
  validates :title, presence: true, length: { minimum: 3 }
end
