# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question!, only: %i[edit update show destroy]

  def index
    @pagy, @questions = pagy Question.order(created_at: :desc)
    @questions = @questions.decorate
  end

  def new
    @question = Question.new
  end

  def create
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
    @question = @question.decorate
    @answer = @question.answers.build
    # @user = User.find(@answer.user_id)
    @pagy, @answers = pagy @question.answers.order created_at: :desc
  end

  def destroy
    @question.destroy
    redirect_to questions_path
    flash[:success] = 'Question was deleted'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question!
    @question = Question.find params[:id]
  end
end
