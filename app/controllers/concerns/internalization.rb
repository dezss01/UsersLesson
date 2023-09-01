# frozen_string_literal: true

module Internalization
  extend ActiveSupport::Concern

  included do
    # before_action :set_locale
    #
    # private
    #
    # def set_locale
    #   I18n.locale = params[:locale] || I18n.default_locale
    #   session[:locale] = I18n.locale
    # end

    around_action :switch_locale

    private

    def switch_locale(&action)
      locale = params[:locale] || locale_from_headers || I18n.default_locale
      response.set_header('Content-Language', locale)
      I18n.with_locale locale, &action
    end

    def locale_from_url
      locale = pa rams[:locale]

      return locale if I18n.avalible_locales.map(&:to_s).include?(locale)

      nil
    end

    def default_url_options
      { locale: I18n.locale }
    end

    # Addepted from https://github.com/rack/rack-contrib/blob/main/lib/rack/contrib/locale.rb
    def locale_from_headers
      header = request.env['HTTP_ACCEPT_LANGUAGE ']

      return if header.nil?

      locales = header.gsub(/\s+/, '').split(',').map do |language_tag|
        locale, quality = language_tag.split(/;q=/i)
        quality = quality ? quality.to_f : 1.0
        [locale, quality]
      end.reject do |(locale, quality)|
        locale == '*' || quality.zero?
      end.sort_by do |(_, quality)|
        quality
      end.map(&:first)

      return if locales.empty?

      if I18n.enforce_available_locales
        locale = locales.reverse.find { |locale| I18n.available_locales.any? { |al| match?(al, locale) } }
        I18n.available_locales.find { |al| match?(al, locale) } if locale
      else
        locales.last
      end
    end

    def match?(s1, s2)
      s1.to_s.casecmp(s2.to_s).zero?
    end
  end
end
