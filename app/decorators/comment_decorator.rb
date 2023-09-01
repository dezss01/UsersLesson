# frozen_string_literal: true

class CommentDecorator < ApplicationDecorator
  delegate_all
  decorates_associations :user

  def for?(commentable)
    commentable = commentable.object if commentable.decorated?
    commentable == self.commentable
  end
end
