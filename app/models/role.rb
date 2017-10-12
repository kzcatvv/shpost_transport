class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  validates_presence_of :user_id, :team_id, :role, :message => '不能为空字符'
  validates_uniqueness_of :user_id, scope: [:team_id, :role], :message => '该角色在该仓库中角色已存在'
  
  ROLE = { admin: '管理员', user: '用户'}

  def self.get_teams_by_user_id(user_id)
    Role.where("user_id = ?", user_id).group(:team_id)
  end
end
