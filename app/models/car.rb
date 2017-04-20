class Car < ActiveRecord::Base
  belongs_to :team
  belongs_to :default_driver, class_name: 'Driver', foreign_key: "default_driver_id"

  validates_presence_of :car_number, :message => '不能为空字符'

  validates_uniqueness_of :car_number, :message => '该车已存在'

  before_save :before_default_driver
  after_save :after_default_driver

  TYPE_SHOW = {sk: "小型客车",bk: "大型客车",sh: "小型货车",bh: "大型货车"}

  def get_car_type
    TYPE_SHOW[self.car_type.to_sym]
  end

  def before_default_driver
    # if !self.default_driver.blank? && self.default_driver.default_car_id != self.id
    #   if !self.default_driver.default_car_id.blank?
    #     puts self.car_number + " " + self.default_driver.name + " " + self.default_driver.default_car.car_number
    #     self.default_driver.default_car.update default_driver_id: nil
    #   end
    # end
    Car.where.not(id: self.id).where(default_driver_id: self.default_driver_id).update_all default_driver_id: nil
  end

  def after_default_driver
    # if !self.default_driver.blank? && self.default_driver.default_car_id != self.id
    #   if !self.default_driver.default_car.blank?
    #     self.default_driver.default_car.update default_driver_id: nil
    #   end
    #   self.default_driver.update default_car_id: self.id
    # end
    Driver.where(id: self.default_driver_id).update_all default_car_id: self.id
    Driver.where.not(id: self.default_driver_id).where(default_car_id: self.id).update_all default_car_id: nil
  end
end
