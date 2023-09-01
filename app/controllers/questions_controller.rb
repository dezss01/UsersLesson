# frozen_string_literal: true

class QuestionsController < ApplicationController
  include QuestionsAnswers

  before_action :set_question!, only: %i[edit update show destroy]
  before_action :fetch_tags, only: %i[new edit]

  def index
    @pagy, @questions = pagy Question.all_by_tags(params[:tag_ids])
    @questions = @questions.decorate
  end

  def new
    @question = Question.new
  end

  def create
    # Для текущего пользователя построить вопрос с параметрами из question_params
    @question = current_user.questions.build question_params
    if @question.save
      flash[:success] = 'You create a new question'
      redirect_to questions_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @question.update question_params
      redirect_to questions_path
      flash[:success] = 'Question successfully updated'
    else
      render :edit, status: :unprocessable_entity
      flash.now[:alert] = "Question was't updated"
    end
  end

  def show
    load_question_answers(do_render: false)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
    flash[:success] = 'Question was deleted'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, tag_ids: [])
  end

  def set_question!
    @question = Question.find params[:id]
  end

  def fetch_tags
    @tags = Tag.all
  end
end
