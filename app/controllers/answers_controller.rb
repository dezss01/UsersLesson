class AnswersController < ApplicationController
  before_action :set_question!
  before_action :set_answer!, only: %i[edit update destroy]
  before_action :set_answers!, only: :create

  def new; end

  def create
    @answer = @question.answers.build answer_create_params

    if @answer.save
      flash[:success] = 'Answer created!'
      redirect_to question_path(@question)
    else
      @question = @question.decorate
      @pagy, @answers = pagy @question.answers.order created_at: :desc
      @answers = @answers.decorate
      render 'questions/show', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @answer.update answer_update_params
    if @answer.save
      flash[:success] = 'Answer was updated'
      redirect_to question_path(@question, anchor: "answer-#{@answer.id}")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    flash[:success] = 'Answer deleted!'
    redirect_to question_path(@question)
  end


  private

  def set_question!
    @question = Question.find params[:question_id]
  end

  def set_answers!
    @answers = @question.answers.order created_at: :desc
  end

  def set_answer!
    @answer = @question.answers.find params[:id]
  end

  def answer_create_params
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end

  def answer_update_params
    params.require(:answer).permit(:body)
  end
end
