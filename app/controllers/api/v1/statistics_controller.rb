class Api::V1::StatisticsController < Api::V1::ApiController

  def index
    @statistics = Statistic.all.joins(:player).includes(:player)

    @statistics = @statistics.where(season: params[:season]) if params[:season].present?
    @statistics = @statistics.where("players.position = ? ", params[:position]) if params[:position].present?
    @statistics = @statistics.where("players.active = ? ", params[:active]) if params[:active].present?
    @players = @players.first(params[:count]) if params[:count].present?

    expose @statistics, include: [:player]
  end

  def trending_players
  	params[:season] = CURRENT_SEASON
    params[:round] = params[:round] || CURRENT_ROUND.to_i - 1

    @statistics = Statistic.all.joins(:player).includes(player: :team)

    @statistics = @statistics.where(season: params[:season]) if params[:season].present?
  	#@statistics = @statistics.where("statistics.week_#{params[:round]} ->> '#{params[:order]}' != '0'") if params[:order] and params[:round]
  	@statistics = @statistics.order("statistics.week_#{params[:round]} -> '#{params[:order]}' DESC") if params[:order] and params[:round]
  	@statistics = @statistics.first(params[:limit]) if params[:limit]

    expose @statistics, include: [player: :team]
  end	

end