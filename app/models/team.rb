class Team < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :cars, dependent: :destroy
  has_many :drivers, dependent: :destroy
  has_many :stations, dependent: :destroy
  belongs_to :leader, class_name: 'User', foreign_key: "leader_id"

  validates_presence_of :name, :message => '不能为空字符'

  validates_uniqueness_of :name, :message => '该车队已存在'

end
