class Api::V1::StatisticsController < Api::V1::ApiController

  def index
    @statistics = Statistic.all
    expose @statistics
  end

end