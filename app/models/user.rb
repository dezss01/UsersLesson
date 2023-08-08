# frozen_string_literal: true

class User < ApplicationRecord
  # создает виртуальный атрибут :old_password и :remember_token
  attr_accessor :old_password, :remember_token

  has_secure_password validations: false

  # валидация на то что пароль должен быть подтвержден и пароль можно оставить пустым (allow_blank:)
  # и длина пароля от 4 до 70 символов
  validates :password, confirmation: true, allow_blank:  true,
                       length: { minimum: 4, maximum: 70 }

  validate :password_presence

  # проверка правильно ли введен старый пароль выполняемая только
  # при редактировании профиля пользователя
  # и только если введен новый пароль (пользователь изменяет пароль)
  validate :correct_old_password, on: :update, if: -> { password.present? }
  validate :password_complexity

  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  validates :name, presence: true

  # метод для запоминания пользователя. Генерирует токен на основе которого делается хеш.
  # Записывает данный токен в БД
  def remember_me
    self.remember_token = SecureRandom.urlsafe_base64
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, digest(remember_token)
    # rubocop:enable Rails/SkipsModelValidations
  end

  # проверяет что тот токен который нам передается и тот токен который есть в БД одно и тоже
  # если remember_token_digest.present? возвращает true то метод вернет false и не будет проверять
  # соответствие токенов
  def remember_token_authenticated?(remember_token)
    return false if remember_token_digest.blank?

    BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
  end

  # ставит значение remember_token_digest в БД в nil
  # и значение self.remember_token устанавливает в nil
  def forget_me
    # rubocop:disable Rails/SkipsModelValidations
    update_column :remember_token_digest, nil
    # rubocop:enable Rails/SkipsModelValidations
    self.remember_token = nil
  end

  private

  # метод генерирует хеш на основе строки переданной в параметрах метода
  # честно спизжен из видосов, а в видосе тоже от куда-то спизжен
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost:)
  end

  # код из гитхаба device который проверяет введенный пароль на соответсвие регулярному выражению
  # и если не соответствует - то записывает ошибку в массив errors
  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{4,70}$/

    errors.add :password,
               'Complexity requirement not met. Length should be 4-70 characters and include: 1 uppercase,
1 lowercase, 1 digit and 1 special character'
  end

  # добавляет в массив errors ошибку о том что пароль не может быть пустым в случае если пароль еще не был задан
  def password_presence
    errors.add(:password, :blank) if password_digest.blank?
  end

  # метод проверяет соответсвует ли ввод старого пароля тому что был в БД
  # Для того что бы не было ошибки с вводом одинаковых паролей в поля пароль, поддтверждение пароля и старый пароль
  # необходимо использовать напрямую BCrypt::Password.new(password_digest_was) ----------!!!!!!!!!!!!!!------------
  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end
end
