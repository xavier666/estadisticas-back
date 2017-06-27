class SettingsController < ApplicationController

  load_and_authorize_resource

  def index
    @settings = Setting.all
  end

  def new
    @setting = Setting.new
  end

  def create
    @setting = Setting.create(setting_params)
    @settings = Setting.all
  end

  def edit
  end

  def update
    @setting.update_attributes(setting_params)
  end

  def destroy
    @setting.destroy
  end

  private
    def find_setting
      @setting = Setting.find(params[:id])
    end

    def setting_params
      params.require(:setting).permit([:name, :key, :value])
    end
end