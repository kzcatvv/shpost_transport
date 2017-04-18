class Station < ActiveRecord::Base
  belongs_to :team

  validates_presence_of :name, :message => '不能为空字符'

  validates_uniqueness_of :name, :message => '该站点已存在'

end
