class AnswerDecorator < ApplicationDecorator
  delegate_all
  decorates_associations :user

  def formatted_time(obj)
    l obj.created_at, format: :long
  end

end
