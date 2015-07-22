class Admin::SpiLogController < Admin::BaseController

  layout "spi_log"

  def full_index
    index 10000
  end

  def index(records = 10)
    @records = REDIS.lrange("spi_log", 0, records)
    render :index
  end

  def clear
    REDIS.del("spi_log")
    redirect_to :spi_log
  end

end
