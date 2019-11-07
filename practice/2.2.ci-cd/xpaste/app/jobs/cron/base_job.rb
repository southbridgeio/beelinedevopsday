# frozen_string_literal: true

# Базовый класс для парсинга и валидации cron задач из файла config/schedule.yml
class Cron::BaseJob
  include Sidekiq::Worker

  def cron_next_time
    cron_parser.next_time
  end

  def cron_previous_time
    cron_parser.previous_time
  end

  def cron_parser
    @cron_parser ||= Cron::Parser.new(self)
  end

  # Пропускает задачи, которые были выполнены в период между previous и next
  def performable?(datetime)
    return true if datetime.nil?

    !(cron_previous_time..cron_next_time).cover? datetime
  end

  def logger
    @logger ||= Rails.logger
  end

  # Необходимо для быстровыполняемых задач,чтобы значение cron
  # не совпало в точности с началом задачи.
  # Sidekiq::Cron::Parser.new(self) выполнит поиск предыдущего запуска и будущего.
  # Пример:
  # Допустим сегодня понедельник и значения "0 8 * * 1" - запускать каждый понедельник в 8:00
  # если в момент запуска задачи Time.now вернет полностью идентичное время, то
  # cron_previous_time вернет значение не сегодняшний день в 8:00, а предыдущий ПН.
  def cron_prepare
    return if Rails.env.test?
    sleep 1
  end

  # Callback для Sidekiq::Batch
  # Можем использовать для отправки уведомлений, например в Errbit
  def on_complete(_status, options)
    options = options.deep_symbolize_keys

    status   = Sidekiq::Batch::Status.new(options[:bid])
    failures = Sidekiq::Failures::FailureSet.new

    ids = failures.select { |deadjob| status.failure_info.include? deadjob.jid }
                 .map(&:args).flatten

    if ids.present?
      Airbrake.notify_sync("#{options[:on_failed][:msg]} #{ids}")
    elsif options[:on_success].present?
      Airbrake.notify_sync(options[:on_success][:msg])
    end
  end
end
