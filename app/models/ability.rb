class Ability
  include CanCan::Ability

  def initialize(user = nil)
    user ||= User.new
    if user.superadmin?
        can :manage, User
        can :manage, Unit
        can :manage, UserLog
        can :manage, Role
        can :role, :unitadmin
        can :role, :user
        can :manage, Specification, commodity: {unit_id: user.unit_id}
        can [:autocomplete_specification_name,:pd_autocomplete_specification_name,:br_autocomplete_specification_name,:ko_autocomplete_specification_name,:os_autocomplete_specification_name,:ms_autocomplete_specification_name,:si_autocomplete_specification_name], Specification, commodity: {unit_id: user.unit_id}
        can :si_autocomplete_specification_name, Relationship, business: {unit_id: user.unit_id}
        # cannot :role, :superadmin
        cannot [:role, :create, :destroy, :update], User, role: 'superadmin'
        can :update, User, id: user.id
        can :manage, Sequence
        #can :manage, User
        can :manage, InterfaceInfo
        can :manage, InterfaceSender
        can :manage, UpDownload
        can :manage, Logistic
        can :manage, CountryCode


        cannot :resend, InterfaceInfo do |interface_info|
            (interface_info.status == "success") || (interface_info.class_name.blank?) || (interface_info.method_name.blank?)
        end

        cannot :resend, InterfaceSender do |interface_sender|
            (interface_sender.status == "success")
        end

        cannot :rebuild, InterfaceSender do |interface_sender|
            (interface_sender.object_class.blank? || interface_sender.object_id.blank? || interface_sender.status == "success")
        end
        
    elsif user.unitadmin?
    #can :manage, :all
        can [:manage,:br_autocomplete_specification_name], Business, unit_id: user.unit_id
        can :manage, Supplier, unit_id: user.unit_id
        can :manage, Contact, supplier: {unit_id: user.unit_id}
        can :manage, Goodstype, unit_id: user.unit_id
        can :manage, Commodity, unit_id: user.unit_id
        can :manage, Specification, commodity: {unit_id: user.unit_id}
        can :new, Relationship
        can :manage, Consumable, unit_id: user.unit_id
        can :manage, ConsumableStock, unit_id: user.unit_id
        can :read, ConstockLog
        can [:read,:hotprint_ready,:hotprint_show,:gjxbp,:gjxbg,:gnxb,:tcsd,:tcxb,:ems,:swtd], Logistic
        can :manage, BigPacket
        cannot :rebuild, BigPacket do |big_packet|
            !big_packet.can_rebuild?
        end
        cannot :resend, BigPacket do |big_packet|
            !big_packet.can_resend?
        end

            # can :manage, MoveStock, unit_id: user.unit_id
            # can :manage, Inventory, unit_id: user.unit_id
            # can :manage, Task, unit_id: user.unit_id

        can [:autocomplete_specification_name,:pd_autocomplete_specification_name,:br_autocomplete_specification_name,:ko_autocomplete_specification_name,:os_autocomplete_specification_name,:ms_autocomplete_specification_name,:si_autocomplete_specification_name], Specification, commodity: {unit_id: user.unit_id}

        can [:manage,:autocomplete_specification_name,:br_autocomplete_specification_name], Relationship, business: {unit_id: user.unit_id}

        can [:read, :update], Unit, id: user.unit_id
        can :manage, Sequence, id: user.unit_id
        can :manage, Storage, unit_id: user.unit_id

        can :storage, Unit, id: user.unit_id

        can :read, UserLog, user: {unit_id: user.unit_id}
        can :destroy, UserLog, operation: '订单导入'

        can :manage, User, unit_id: user.unit_id

        can :manage, Role
        cannot :role, User, role: 'superadmin'
        can :role, :unitadmin
        can :role, :user
        can [:read, :up_download_export, :org_stocks_import, :org_single_stocks_import], UpDownload
        cannot [:create, :to_import, :up_download_import,:destroy], UpDownload
        
        # cannot :role, User, role: 'unitadmin'
        cannot [:create, :destroy, :update], User, role: ['unitadmin', 'superadmin']
        can :update, User, id: user.id

        can :manage, InterfaceInfo, unit_id: user.unit_id

        cannot :resend, InterfaceInfo do |interface_info|
            (interface_info.status == "success") || (interface_info.class_name.blank?) || (interface_info.method_name.blank?)
        end

        can :manage, InterfaceSender, unit_id: user.unit_id

        cannot :resend, InterfaceSender do |interface_sender|
            (interface_sender.status == "success")
        end

        cannot :rebuild, InterfaceSender do |interface_sender|
            (interface_sender.object_class.blank? || interface_sender.object_id.blank? || interface_sender.status == "success")
        end

        can :destroy, Task, status: "doing"

        can :query_order_report, :orders
        can :order_statistic_details, :orders
        can :manage, SequenceNo
        cannot :destroy, Order, status: ['spliting', 'splited', 'printed', 'picking', 'checked', 'packed', 'delivering', 'delivered', 'declined', 'returned', 'cancel', 'packeted']
        # can :manage, TarrifPackage, business: {unit_id: user.unit_id}
        # can :manage, TarrifItem, business: {unit_id: user.unit_id}
        can :manage, TarrifPackage
        can :manage, TarrifItem
        can :manage, TarrifFee
        can :manage, TarrifLog
        # can :manage,BusinessRelationship
        
    elsif user.user?
        can :update, User, id: user.id
        can :read, UserLog, user: {id: user.id}

        can :read, Unit, id: user.unit_id


        can :read, Business, unit_id: user.unit_id
        can :read, Supplier, unit_id: user.unit_id
        can :read, Contact, supplier: {unit_id: user.unit_id}
        can :read, Goodstype, unit_id: user.unit_id
        can :read, Commodity, unit_id: user.unit_id
        can :read, Specification, commodity: {unit_id: user.unit_id}

        can :autocomplete_specification_name, Specification, commodity: {unit_id: user.unit_id}

        can :read, Relationship, business: {unit_id: user.unit_id}

        cannot :manage, InterfaceInfo
        cannot :manage, InterfaceSender, unit_id: user.unit_id
        cannot :manage, BigPacket

        can [:read,:hotprint_ready,:hotprint_show,:gjxbp,:gjxbg,:gnxb,:tcsd,:tcxb,:ems,:swtd], Logistic

        can [:read, :up_download_export], UpDownload
        cannot [:create, :to_import, :up_download_import,:destroy], UpDownload

        cannot :query_order_report, :orders
        cannot :order_statistic_details, :orders

    else
        cannot :manage, :all
        #can :update, User, id: user.id
        cannot :read, User
        cannot :read, Area
        cannot :read, Commodity
        cannot :read, Business

        cannot :manage, InterfaceInfo
        cannot :manage, InterfaceSender, unit_id: user.unit_id
        can :query_order_report, :orders
        can :order_statistic_details, :orders
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
