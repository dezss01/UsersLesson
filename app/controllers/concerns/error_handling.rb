# frozen_string_literal: true
module ErrorHandling

  extend ActiveSupport::Concern

  included do
    # обработка ошибки ActiveRecord::RecordNotFound, with: :notfound, где with: :notfound указание с помощью
    # какого метода обрабатывать эту ошибку
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    include Authentication

    private

    # метод для обработки ошибки ActiveRecord::RecordNotFound
    # принимает объект exception и записывает его в журнал логов
    def record_not_found(exception)
      logger.warn exception
      render file: 'public/404.html', status: :not_found, layout: false
    end
  end
end