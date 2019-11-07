# frozen_string_literal: true

# Задача по удалению записей по назначенному времени
class Cron::Paste::DeleteJob < Cron::BaseJob
  def perform
    log(:info, 'удаляем записи на текущую дату')
    ::Paste.where('will_be_deleted_at <= ?', Time.now).delete_all
  end

  private

  def log(method, value)
    logger.tagged(:cron, :delete_expired_paste) { logger.public_send(method, value) }
  end
end
