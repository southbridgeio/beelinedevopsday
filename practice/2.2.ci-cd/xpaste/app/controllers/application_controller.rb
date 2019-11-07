# frozen_string_literal: true

# Контроллер приложения
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_action :set_locale

  rescue_from ActiveRecord::RecordNotFound do
    render file: 'public/404.html', status: :not_found, layout: false
  end

  rescue_from ActionView::MissingTemplate, with: :not_found

  rescue_from I18n::InvalidLocale, with: :locale_error

  private

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || http_accept_language.compatible_language_from(I18n.available_locales)
    session[:locale] = I18n.locale if session[:locale] != I18n.locale
  end

  def locale_error
    render plain: 'Unsupported locale. Available locale is ru/en'
  end
end
