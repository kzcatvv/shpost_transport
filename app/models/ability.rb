class Ability
  include CanCan::Ability

  def initialize(user = nil)
    user ||= User.new
    if user.superadmin?
        can :manage, User
        can :manage, Team
        can :read, Car
        can :read, Driver
        can :read, Station
        can :manage, UserLog
        can :manage, Role
        can :role, :teamadmin
        can :role, :user

        cannot [:role, :create, :destroy, :update], User, role: 'superadmin'
    elsif user.teamadmin?
        can [:read,:update], Team, id: user.team_id
        can :manage, Car, team_id: user.team_id
        can :manage, Driver, team_id: user.team_id
        can :manage, Station, team_id: user.team_id

        can :read, UserLog, user: {team_id: user.team_id}

        can :manage, User, team_id: user.team_id

        can :manage, Role
        cannot :role, User, role: 'superadmin'
        can :role, :teamadmin
        can :role, :user
        
        cannot [:create, :destroy, :update], User, role: ['teamadmin', 'superadmin']
        can :update, User, id: user.id

        # can :manage,BusinessRelationship
        
    elsif user.user?
        can :update, User, id: user.id
        # can :read, UserLog, user: {id: user.id}

        can :read, Team, id: user.team_id
        can :read, Car, team_id: user.team_id
        can :read, Driver, team_id: user.team_id
        can :read, Station, team_id: user.team_id

    else
        cannot :manage, :all
        #can :update, User, id: user.id
        cannot :read, User
        
    end


    end
end




# if user.admin?(storage)


# Define abilities for the passed in user here. For example:
#
#   user ||= User.new # guest user (not logged in)
#   if user.admin?
#     can :manage, :all
#   else
#     can :read, :all
#   end
#
# The first argument to `can` is the action you are giving the user 
# permission to do.
# If you pass :manage it will apply to every action. Other common actions
# here are :read, :create, :update and :destroy.
#
# The second argument is the resource the user can perform the action on. 
# If you pass :all it will apply to every resource. Otherwise pass a Ruby
# class of the resource.
#
# The third argument is an optional hash of conditions to further filter the
# objects.
# For example, here the user can only update published articles.
#
#   can :update, Article, :published => true
#
# See the wiki for details:
# https://github.com/ryanb/cancan/wiki/Defining-Abilities
