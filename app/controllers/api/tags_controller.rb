module Api
  class TagsController < ApplicationController
    def index
      tags = Tags.arel_table
      @tags = Tag.where(tags[:title].matches("%#{params[:term]}%"))

      respond_to(&:json)
    end
  end
end
