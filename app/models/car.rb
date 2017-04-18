class Car < ActiveRecord::Base
  belongs_to :team
  belongs_to :default_driver, class_name: 'Driver', foreign_key: "default_driver_id"

  validates_presence_of :car_number, :message => '不能为空字符'

  validates_uniqueness_of :car_number, :message => '该车已存在'

  TYPE_SHOW = {sk: "小型客车",bk: "大型客车",sh: "小型货车",bh: "大型货车"}

  def get_car_type
    TYPE_SHOW[self.car_type.to_sym]
  end
end
