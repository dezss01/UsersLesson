# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def nav_tab(title, url, options = {})
    # здесь мы вытаскиваем локольную переменную current_page из options
    current_page = options.delete :current_page

    # если current_page == title то назначаем класс text-secondary
    # иначе класс text-white
    css_class = current_page == title ? 'text-secondary' : 'text-white'

    options[:class] = if options[:class]
                        "#{options[:class]} #{css_class}"
                      else
                        css_class
                      end
    link_to title, url, options
  end

  def currently_at(current_page)
    # locals передает в макет который рендерится локальную переменную current_page
    render partial: 'shared/menu', locals: { current_page: }
  end

  # Метод возвращает значение title из страницы
  # на которой сделан <%= provide :page_title, 'Название Страницы' %>
  def full_title(page_title = '')
    base_title = 'AskIt'
    if page_title.present?
      "#{page_title} | #{base_title}"
    else
      base_title
    end
  end

  # форматирует время created_at под локаль
  # принимает объект ActiveRecord
  def formatted_time(obj)
    l obj.created_at, format: :long
  end

  def pagination(obj)
    raw(pagy_bootstrap_nav(obj)) if obj.pages > 1
  end
end
