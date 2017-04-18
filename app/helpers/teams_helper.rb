module TeamsHelper
  CLASS_NAME = "team"
  def create_auto_user(obj_name = nil)
    if obj_name.blank?
      obj_name = "user_id"
    end
    concat text_field_tag("auto_complete_"+CLASS_NAME+"_"+obj_name.to_s,(@team.leader.try :name), 'data-autocomplete' => (autocomplete_user_name_auto_complete_index_path + "?cls=#{CLASS_NAME}&obj=#{obj_name.to_s}"))
    hidden_field(CLASS_NAME.to_sym,obj_name.to_s);
  end
end
