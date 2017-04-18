module CarsHelper
  CLASS_NAME = "car"
  def create_auto_driver(obj_name = nil)
    if obj_name.blank?
      obj_name = "driver_id"
    end
    concat text_field_tag("auto_complete_"+CLASS_NAME+"_"+obj_name.to_s,(@car.default_driver.try :name), 'data-autocomplete' => (autocomplete_driver_name_auto_complete_index_path + "?cls=#{CLASS_NAME}&obj=#{obj_name.to_s}"))
    hidden_field(CLASS_NAME.to_sym,obj_name.to_s);
  end
end
