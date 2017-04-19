class DriversController < ApplicationController
  load_and_authorize_resource :driver
  # before_action :set_driver, only: [:show, :edit, :update, :destroy]

  def index
    @drivers_grid = initialize_grid(@drivers)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @driver.save
        format.html { redirect_to @driver, notice: I18n.t('controller.create_success_notice', model: '司机')}
        format.json { render action: 'show', status: :created, location: @driver }
      else
        format.html { render action: 'new' }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @driver.update(driver_params)
        format.html { redirect_to @driver, notice: I18n.t('controller.update_success_notice', model: '司机') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url }
      format.json { head :no_content }
    end
  end

  private
    def set_driver
      @driver = Driver.find(params[:id])
    end

    def driver_params
      params.require(:driver).permit(:no, :name, :sex, :work_age, :tel, :team_id, :default_car_id, :birthday)
    end
end
