class UserBulkService < ApplicationService
  attr_reader :archive

  # делаем инициализацию с archive_param
  # в переменную @archive записываем archive_param.tempfile
  # tempfile - это метод который позволяет получить ссылку на загруженный файл
  def initialize(archive_param)
     @archive = archive_param.tempfile
  end

  def call
    # Открывает присланный архив zip
    Zip::File.open(@archive) do |zip_file|
      # берет каждый файл из архива
      zip_file.each do |entry|
        # делаем импорт данных из файла используя гем activerecord-import
        # ignore: true означает что при наличии в БД такого же пользователя как и в файле
        # запись будет проигнорирована, при чем валидации будут сделаны
        User.import users_from(entry), ignore: true
        # binding.pry
      end
    end
  end

  private

  def users_from(entry)
    # парсит файл (entry), сначала используется Zip get_input_stream
    # из файла читаются данные, при чем [0] указывает на номер листа в файле
    # после данные для парсинга передаются в RubyXL
    sheet = RubyXL::Parser.parse_buffer(entry.get_input_stream.read)[0]
    # делаем массив на основе данных
    sheet.map do |row|
      cells = row.cells
      User.new name: cells[0]&.value.to_s,
               email: cells[1]&.value.to_s,
               password: cells[2]&.value.to_s,
               password_confirmation: cells[2]&.value.to_s
    end
  end
end