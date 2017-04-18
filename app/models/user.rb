class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  belongs_to :team
  has_many :user_logs
  has_many :roles, dependent: :destroy

  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :username, :name, :team_id, :role, :message => '不能为空字符'#,

  validates_uniqueness_of :username, :message => '该用户已存在'

  ROLE = { superadmin: '超级管理员', teamadmin: '车队管理员', user: '用户' }

  def rolename
    User::ROLE[role.to_sym]
  end

  def superadmin?
    (role.eql? 'superadmin') ? true : false
  end

  def teamadmin?
    (role.eql? 'teamadmin') ? true : false
  end

  def user?
    (role.eql? 'user') ? true : false
  end

  def email_required?
    false
  end

  def password_required?
    encrypted_password.blank? ? true : false
  end

end
