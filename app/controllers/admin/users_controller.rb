# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_user_authentication

    def index
      respond_to do |format|
        format.html do
          @pagy, @users = pagy User.order(created_at: :desc)
        end

        # format.zip do
        #   respond_with_zipped_users
        # end
        # аналогично предыдущему коду
        format.zip { respond_with_zipped_users }
      end
    end

    def create
      if params[:archive].present?
        UserBulkService.call params[:archive]
        flash[:success] = 'Users Imported!'
      end

      redirect_to admin_users_path
    end

    private

    def respond_with_zipped_users
      # compressed_filestream - создает (zos.put_next_entry) для каждого юзера файл в памяти с именем user_id.xlsx
      # потом записывает (zos.print render_to_string) в этот файл данные:
      # лейоут отключен
      # handlers - это обработчик, в нашем случае это axlsx, обрабатываемый файл
      # должен лежать в views/admin/users/user.xlsx.axlsx что мы и указываем в template
      # formats - формат в котором ведется запись данных (конечный формат файла в который мы ведем запись)
      # template - шаблон из которого берутся данные
      # locals передает в шаблон локальную переменную с именем user подставленную из do |user|
      compressed_filestream = Zip::OutputStream.write_buffer do |zos|
        User.order(created_at: :desc).each do |user|
          zos.put_next_entry "user_#{user.id}.xlsx"
          zos.print render_to_string(
            layout: false, handlers: [:axlsx],
            formats: [:xlsx],
            template: 'admin/users/user',
            locals: { user: }
          )
        end
      end

      # делаем перенос каретки в начало файла
      compressed_filestream.rewind

      # после стандартным методом рельс send_data берем compressed_filestream
      # и читаем его (записываем) в файл с filename: 'users.zip'
      send_data compressed_filestream.read, filename: 'users.zip'
    end
  end
end
