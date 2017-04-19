class AutoCompleteController < ApplicationController
  autocomplete :user, :name, :full => true
  autocomplete :car, :car_number, :full => true
  autocomplete :driver, :name, :full => true
  autocomplete :station, :name, :full => true

  def autocomplete_user_name
    term = params[:term]
    class_name = params[:cls]
    obj_name = params[:obj]
    results = User.where("name like ?", "%#{term}%")
    render :json => results.map { |result| {:id => result.id, :label => result.name, :value => result.name, :obj => class_name + "[" + obj_name + "]"} }
  end

  def autocomplete_car_car_number
    term = params[:term]
    class_name = params[:cls]
    obj_name = params[:obj]
    results = Car.where("car_number like ?", "%#{term}%")
    render :json => results.map { |result| {:id => result.id, :label => result.car_number, :value => result.car_number, :obj => class_name + "[" + obj_name + "]"} }
  end

  def autocomplete_driver_name
    term = params[:term]
    class_name = params[:cls]
    obj_name = params[:obj]
    results = Driver.where("name like ?", "%#{term}%")
    render :json => results.map { |result| {:id => result.id, :label => (result.name + " " + result.get_sex + " " + result.age.to_s + "岁"), :value => result.name, :obj => class_name + "[" + obj_name + "]"} }
  end

  def autocomplete_station_name
    term = params[:term]
    class_name = params[:cls]
    obj_name = params[:obj]
    results = Station.where("name like ? or address like ?", "%#{term}%", "%#{term}%")
    render :json => results.map { |result| {:id => result.id, :label => result.name, :value => result.name, :obj => class_name + "[" + obj_name + "]"} }
  end

  # def autocomplete_name
  #   term = params[:term]
  #   obj = params[:objid].humanize.safe_constantize
  #   #binding.pry
  #   results = []
  #   if obj.is_a? User
  #     results = User.where("name like ?", "%#{term}%")
  #     render :json => results.map { |result| {:id => result.id, :label => result.name, :value => result.name, :obj => params[:objid]} }
  #   elsif obj.is_a? Car
  #     results = Car.where("car_number like ?", "%#{term}%")
  #     render :json => results.map { |result| {:id => result.id, :label => result.car_number, :value => result.car_number, :obj => params[:objid]} }
  #   elsif obj.is_a? Driver
  #     results = Driver.where("name like ?", "%#{term}%")
  #     render :json => results.map { |result| {:id => result.id, :label => (result.name + " " + result.sex_in_chinese + " " + result.age), :value => result.name, :obj => params[:objid]} }
  #   elsif obj.is_a? Station
  #     results = Station.where("name like ? or address like ?", "%#{term}%", "%#{term}%")
  #     render :json => results.map { |result| {:id => result.id, :label => result.name, :value => result.name, :obj => params[:objid]} }
  #   end
  #   render :json => nil
  # end
end