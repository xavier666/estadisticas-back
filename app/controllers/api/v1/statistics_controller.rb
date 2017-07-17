class Api::V1::StatisticsController < Api::V1::ApiController

  def index
    @statistics = Statistic.all.joins(:player).includes(:player)

    @statistics = @statistics.where(season: params[:season]) if params[:season].present?
    @statistics = @statistics.where("players.position = ? ", params[:position]) if params[:position].present?
    @statistics = @statistics.where("players.active = ? ", params[:active]) if params[:active].present?

    #@statistics = @statistics.pluck("week_#{params[:round]}") if params[:round].present?

    expose @statistics, include: [:player]
  end

end