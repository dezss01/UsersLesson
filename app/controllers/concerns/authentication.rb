# frozen_string_literal: true

require 'active_support/concern'

module Authentication
  extend ActiveSupport::Concern
  # rubocop: disable Metrics/BlockLength
  included do
    private

    # метод возвращает текущего пользователя -> @current_user, если он есть в сессии
    # или в куках
    def current_user
      user = session[:user_id].present? ? user_from_session : user_from_token

      @current_user = user&.decorate
    end

    # возвращает current_user если он есть в сессии
    def user_from_session
      User.find_by(id: session[:user_id])
    end

    # логинит поль зователя и присваивает экземпляр методу current_user
    # если пользователь аутентифицируется по кукам :remember_token
    def user_from_token
      user = User.find_by(id: cookies.encrypted[:user_id])
      token = cookies.encrypted[:remember_token]

      return unless user&.remember_token_authenticated?(token)

      sign_in user
      user
    end

    # метод проверяет присутствует ли пользователь в сессии
    def user_signed_in?
      current_user.present?
    end

    # метод записывает в session[:user_id] id пользователя который был передан методу как аргумент
    def sign_in(user)
      session[:user_id] = user.id
    end

    # метод удаляет из сессии параметр :user_id
    # и вызывает метод forget на current_user
    def sign_out
      forget current_user
      session.delete :user_id
    end

    # метод вызывает на пользователе метод remember_me после чего записывает в куки зашифрованный
    # remember_token сгенерированный для текущего пользователя а так же записывает в куки id пользователя
    def remember(user)
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token
      cookies.encrypted.permanent[:user_id] = user.id
    end

    # метод удаляет данные :user_id и :remember_token из кук
    # и вызывает на переданном в качестве параметра объекте user метод forget_me
    def forget(user)
      user.forget_me
      cookies.delete :user_id
      cookies.delete :remember_token
    end

    # метод возвращает false если пользователь в сессии, иначе
    # флеш и переход на рут
    def require_no_authentication
      return unless user_signed_in?

      flash[:warning] = 'You already sign in!'
      redirect_to root_path
    end

    # метод возвращает true если пользователь в сессии, иначе
    # флеш и переход на рут
    def require_user_authentication
      return if user_signed_in?

      flash[:warning] = 'You are not sign in!'
      redirect_to root_path
    end

    helper_method :current_user, :user_signed_in?
  end
  # rubocop: enable Metrics/BlockLength
end
