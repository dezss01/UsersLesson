# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_user_authentication, only: %i[edit update]
  before_action :set_user!, only: %i[edit update]
  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new user_params
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the app, #{current_user.name_or_email}!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update user_params
      flash[:success] = 'Profile was update!'
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Возвращает пользователя на основании поска в params по id
  def set_user!
    @user = User.find params[:id]
  end

  # метод возвращает хеш params с разрешенными :name, :email, :password, :password_confirmation
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :old_password)
  end
end
