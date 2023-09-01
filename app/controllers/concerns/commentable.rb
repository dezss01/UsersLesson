# frozen_string_literal: true

# Этот консерн будет подключать к любой модели модель комментариев
# и тогда фактически у этой модели будет много комментариев и это виртуальное отношение
# будет называться commentable
module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy
  end
end
