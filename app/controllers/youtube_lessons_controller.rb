class YoutubeLessonsController < ApplicationController
  before_action :set_youtube_lessons!
  def index
    @pagy, @youtube_lessons = pagy @youtube_lessons
  end

  private

  def youtube_lessons_params
    params.require(:youtube_lesson).permit(:number, :name, :link, :description)
  end

  def set_youtube_lessons!
    @youtube_lessons = YoutubeLesson.order(:number)
  end

  def set_youtube_lesson!
    @youtube_lesson = YoutubeLesson.find params[:id]
  end
end
