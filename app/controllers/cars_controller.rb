class CarsController < ApplicationController
  load_and_authorize_resource :car
    
  def index
    @cars_grid = initialize_grid(@cars)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @car.save
        format.html { redirect_to @car, notice: I18n.t('controller.create_success_notice', model: '车辆')}
        format.json { render action: 'show', status: :created, location: @car }
      else
        format.html { render action: 'new' }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to @car, notice: I18n.t('controller.update_success_notice', model: '车辆') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to cars_url }
      format.json { head :no_content }
    end
  end

  private
    def set_car
      @car = Car.find(params[:id])
    end

    def car_params
      params.require(:car).permit(:no, :car_number, :car_type, :car_id, :default_driver_id)
    end
end
