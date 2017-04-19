class Driver < ActiveRecord::Base
  belongs_to :team
  belongs_to :default_car, class_name: 'Car', foreign_key: "default_car_id"

  validates_presence_of :name, :sex, :message => '不能为空字符'

  # validates_uniqueness_of :car_number, :message => '该车已存在'

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
end
