class StationsController < ApplicationController
  load_and_authorize_resource :station
  # before_action :set_station, only: [:show, :edit, :update, :destroy]

  def index
    @stations_grid = initialize_grid(@stations)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @station.save
        format.html { redirect_to @station, notice: I18n.t('controller.create_success_notice', model: '车站')}
        format.json { render action: 'show', status: :created, location: @station }
      else
        format.html { render action: 'new' }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @station.update(station_params)
        format.html { redirect_to @station, notice: I18n.t('controller.update_success_notice', model: '车站') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @station.destroy
    respond_to do |format|
      format.html { redirect_to stations_url }
      format.json { head :no_content }
    end
  end


  private
    def set_station
      @station = Station.find(params[:id])
    end

    def station_params
      params.require(:station).permit(:no, :name, :address, :tel, :team_id)
    end
end
