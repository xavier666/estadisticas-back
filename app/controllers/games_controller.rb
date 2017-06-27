class GamesController < ApplicationController

  load_and_authorize_resource
  require 'nokogiri'
  require 'open-uri'
  require 'webrick/httputils'
  require 'date'

  def index
    @games = Game.active.order(:game_date)
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    @games = Game.active.order(:game_date)
  end

  def edit
  end

  def update
    @game.update_attributes(game_params)
  end

  def destroy
    @game.destroy
  end

  def import
    Game.import_games
    redirect_to games_path and return
  end
  
  def import_table
    Team.import_table
    redirect_to games_path and return
  end

  private
    def find_game
      @game = Player.find(params[:id])
    end

    def game_params
      params.require(:game).permit([:season, :round, :local_team_id, :away_team_id, :game_date, :local_score, :away_score])
    end
end