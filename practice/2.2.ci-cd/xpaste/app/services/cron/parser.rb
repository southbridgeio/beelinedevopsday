# frozen_string_literal: true

# Класс для парсинга и валидации cron задач из файла config/schedule.yml
class Cron::Parser
  attr_reader :job_class, :cron_time

  def initialize(job_class)
    @job_class = job_class.class.to_s
    find_job
  end

  def cron
    @cron_time
  end

  def next_time
    cron.next_time.to_t
  end

  def previous_time
    cron.previous_time.to_t
  end

  private

  def find_job
    job = Sidekiq::Cron::Job.all.select do |yml_job|
      yml_job.klass == job_class
    end.first

    raise "#{job_class} не существует в schedule.yml." if job.blank?

    validate_job(job)
  end

  def validate_job(job)
    @cron_time = Fugit::Cron.parse(job.cron)

    return if @cron_time.present?
    raise "#{job_class} schedule.yml имеет не валидное время."
  end
end
