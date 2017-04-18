module StationsHelper
  CLASS_NAME = "station"
  def create_auto_station(obj_name = nil)
    if obj_name.blank?
      obj_name = "station_id"
    end
    concat text_field_tag("auto_complete_"+CLASS_NAME+"_"+obj_name.to_s,(@station.try :name), 'data-autocomplete' => (autocomplete_station_name_auto_complete_index_path + "?cls=#{CLASS_NAME}&obj=#{obj_name.to_s}"))
    hidden_field(CLASS_NAME.to_sym,obj_name.to_s);
  end
end
