class Driver < ActiveRecord::Base
  belongs_to :team
  belongs_to :default_car, class_name: 'Car', foreign_key: "default_car_id"

  validates_presence_of :name, :sex, :message => '不能为空字符'

  # validates_uniqueness_of :car_number, :message => '该车已存在'
  before_save :before_default_car
  after_save :after_default_car

  SEX = {m: '男', f: '女'}
  
  def age
    if self.birthday.blank?
      self.birthday = Time.new.to_date
    end
    ((Time.new.to_date - self.birthday).to_f/365).round
  end

  def get_sex
    SEX[self.sex.to_sym]
  end

  def before_default_car
    # if !self.default_car.blank? && self.default_car.default_driver_id != self.id
    #   if !self.default_car.default_driver_id.blank?
    #     puts self.name + " " + self.default_car.car_number + " " + self.default_car.default_driver.name
    #     self.default_car.default_driver.update default_car_id: nil
    #   end
    # end
    Driver.where.not(id: self.id).where(default_car_id: self.default_car_id).update_all default_car_id: nil
  end

  def after_default_car
    # if !self.default_car.blank? && self.default_car.default_driver_id != self.id
    #   if !self.default_car.default_driver.blank?
    #     self.default_car.default_driver.update default_car_id: nil
    #   end
    #   self.default_car.update default_driver_id: self.id
    # end
    Car.where(id: self.default_car_id).update_all default_driver_id: self.id
    Car.where.not(id: self.default_car_id).where(default_driver_id: self.id).update_all default_driver_id: nil
  end
end
