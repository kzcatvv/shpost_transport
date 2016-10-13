class Unit < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :storages, dependent: :destroy
  has_many :suppliers, dependent: :destroy
  has_many :goodstypes, dependent: :destroy
  has_many :commodities, dependent: :destroy
  has_many :sequences, dependent: :destroy
  has_many :units, as: :parent
  has_many :tarrif_items, dependent: :destroy
  has_many :tarrif_packages, dependent: :destroy

  validates_presence_of :name, :short_name, :message => '不能为空'
  validates_uniqueness_of :name, :message => '该单位已存在'

  validates_uniqueness_of :short_name, :message => '该缩写已存在'

  UNIT_LEVEL = {1=>'1',2=>'2',3=>'3'}

  def default_storage
    storage = storages.find_by(default_storage: true)
    storage ||= storages.first
  end
end
