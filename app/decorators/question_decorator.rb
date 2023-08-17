# frozen_string_literal: true

class QuestionDecorator < ApplicationDecorator
  delegate_all
  decorates_associations :user
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  def formatted_time(obj)
    l obj.created_at, format: :long
  end
end
