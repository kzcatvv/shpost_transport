module DriversHelper
  CLASS_NAME = "driver"
  def create_auto_car(obj_name = nil)
    if obj_name.blank?
      obj_name = "car_id"
    end
    concat text_field_tag("auto_complete_"+CLASS_NAME+"_"+obj_name.to_s,(@driver.default_car.try :car_number), 'data-autocomplete' => (autocomplete_car_car_number_auto_complete_index_path + "?cls=#{CLASS_NAME}&obj=#{obj_name.to_s}"))
    hidden_field(CLASS_NAME.to_sym,obj_name.to_s);
  end
end
