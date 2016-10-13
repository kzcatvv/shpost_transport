class Ability
  include CanCan::Ability

  def initialize(user,storage = nil)
    user ||= User.new
    if user.superadmin?
        can :manage, User
        can :manage, Unit
        can :manage, UserLog
        can :manage, Role
        can :manage, Storage
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

    if user.admin?(storage)
        can :change, Storage, id: storage.id

        can :manage, Purchase, storage_id: storage.id, status: Purchase::STATUS[:opened]

        can :manage, PurchaseDetail, purchase: {storage_id: storage.id, status: Purchase::STATUS[:opened]}
        
        can :manage, PurchaseArrival, purchase_detail: {purchase: {storage_id: storage.id, status: Purchase::STATUS[:opened]}}

        can [:read,:stock_in], Purchase, storage_id: storage.id, status: Purchase::STATUS[:closed]

        can :read, PurchaseDetail, purchase: {storage_id: storage.id, status: Purchase::STATUS[:closed]}

        can :read, PurchaseArrival, purchase_detail: {purchase: {storage_id: storage.id, status: Purchase::STATUS[:opened]}}

        # cannot :close, Purchase do |purchase|
        #     (purchase.storage_id == storage.id) && (purchase.status == Purchase::STATUS[:opened]) && !purchase.can_close?
        # end
        
        cannot :destroy, Purchase do |purchase|
            (purchase.storage_id == storage.id)&& purchase.has_checked?
        end

        cannot :update, PurchaseDetail do |purchase_detail|
            (purchase_detail.purchase.storage_id == storage.id) && (purchase_detail.status == PurchaseDetail::STATUS[:stock_in])
        end

        
        cannot :destroy, PurchaseDetail do |purchase_detail|
            (purchase_detail.purchase.storage_id == storage.id) && (purchase_detail.status == PurchaseDetail::STATUS[:stock_in])
        end

        can :manage, ManualStock, storage_id: storage.id, status: ManualStock::STATUS[:opened]

        can :manage, ManualStockDetail, manual_stock: {storage_id: storage.id, status: ManualStock::STATUS[:opened]}
        
        can :manage, ManualStockSplit, manual_stock: {storage_id: storage.id}

        can :manage, ManualStockSplitDetail, manual_stock_split: {manual_stock: {storage_id: storage.id}}

        can [:read,:stock_out], ManualStock, storage_id: storage.id, status: ManualStock::STATUS[:closed]

        can :read, ManualStockDetail, manual_stock: {storage_id: storage.id, status: ManualStock::STATUS[:closed]}

        cannot :split, ManualStock do |manual_stock|
            (manual_stock.storage_id == storage.id) && (manual_stock.is_split == true)
        end

        # cannot :close, ManualStock do |manual_stock|
        #     (manual_stock.storage_id == storage.id) && (manual_stock.status == ManualStock::STATUS[:opened]) && !manual_stock.can_close?
        # end
     
        cannot :destroy, ManualStock do |manual_stock|
            (manual_stock.storage_id == storage.id)&& manual_stock.has_checked?
        end

        cannot :update, ManualStockDetail do |manual_stock_detail|
            (manual_stock_detail.manual_stock.storage_id == storage.id) && (manual_stock_detail.status == ManualStockDetail::STATUS[:stock_out])
        end

        cannot :destroy, ManualStockDetail do |manual_stock_detail|
            (manual_stock_detail.manual_stock.storage_id == storage.id) && (manual_stock_detail.status == ManualStockDetail::STATUS[:stock_out])
        end

        can :manage, Keyclientorder, storage_id: storage.id
        can :manage, Keyclientorderdetail, keyclientorder: {storage_id: storage.id}
        cannot :destroy, Keyclientorder do |keyclientorder|
            (keyclientorder.storage_id == storage.id)&& keyclientorder.has_checked?
        end
        can :manage, Order, storage_id: storage.id
        cannot :destroy, Order, status: ['spliting', 'splited', 'printed', 'picking', 'checked', 'packed', 'delivering', 'delivered', 'declined', 'returned', 'cancel', 'packeted']
        can :query_order_report, :orders
        can :order_statistic_details, :orders
        cannot :cancel, Order, status: ['printed','picking']
        cannot :order_recover, Order, status: ['waiting','spliting','splited','printed','packed','delivering','delivered','declined','returned','cancel','packeted']
        can :manage, OrderDetail, order: {storage_id: storage.id}

        # can :manage, Role, storage_id: storage.id

        can :manage, Area, storage_id: storage.id

        can :new, Shelf
        can :manage, Shelf, area: {storage_id: storage.id}

        can :new, Stock
        can :manage, Stock, shelf: {area: {storage_id: storage.id} }

        can :manage, MoveStock, unit_id: user.unit_id
        cannot :destroy, MoveStock do |move_stock|
            (move_stock.storage_id == storage.id)&& move_stock.has_checked?
        end

        can :manage, Inventory, unit_id: user.unit_id
        cannot :destroy, Inventory do |inventory|
            (inventory.storage_id == storage.id)&& inventory.has_checked?
        end
        # can [:read, :getstock, :findstock], Stock, shelf: {area: {storage_id: storage.id}}

        # can :new, Stock, shelf: {area: {storage_id: storage.id}}
        can :manage, StockLog, shelf: {area: {storage_id: storage.id}}
        # can :destroy, StockLog, stock: {shelf: {area: {storage_id: storage.id}}}, status: StockLog::STATUS[:waiting]
        # can :modify, StockLog, stock: {shelf: {area: {storage_id: storage.id}}}
        # can :addtr, StockLog, stock: {shelf: {area: {storage_id: storage.id}}}
        # can :check, StockLog, stock: {shelf: {area: {storage_id: storage.id}}}
        # can :removetr, StockLog, stock: {shelf: {area: {storage_id: storage.id}}}
        # cannot :destroy, StockLog, status: "checked"
        cannot :split, StockLog, status: "checked"
        cannot :destroy, StockLog do |stocklog|
            if stocklog.parent.is_a? Purchase
                stocklog.parent.status == Purchase::STATUS[:closed]
            elsif stocklog.parent.is_a? ManualStock
                stocklog.parent.status == ManualStock::STATUS[:closed]
            elsif stocklog.parent.is_a? Inventory
                stocklog.parent.status == Inventory::STATUS[:closed]
            elsif stocklog.parent.is_a? MoveStock
                stocklog.parent.status == MoveStock::STATUS[:moved]
            elsif stocklog.parent.is_a? OrderReturn
                stocklog.parent.status == OrderReturn::STATUS[:checked]
            elsif stocklog.parent.is_a? Keyclientorder
                stocklog.status == StockLog::STATUS[:checked]
            else
                stocklog.status == StockLog::STATUS[:checked]
            end
        end
        
        can :manage, OrderReturn, storage_id: storage.id

        can :manage, OrderReturnDetail, order_return: {storage_id: storage.id}

        cannot [:update,:destroy], OrderReturn do |order_return|
            (order_return.storage_id == storage.id)&& (["checking","checked"].include?order_return.status)
        end

        cannot [:update,:destroy], OrderReturnDetail do |order_return_detail|
            (order_return_detail.order_return.storage_id == storage.id) && (["checking","checked"].include?order_return_detail.status)
        end


        can :autocomplete_specification_name, Specification, commodity: {unit_id: user.unit_id}

        can :manage, Mobile, storage_id: storage.id

        can :read, Task, storage_id: storage.id
        can :destroy, Task, status: "doing"

        can [:read,:hotprint_ready,:hotprint_show,:gjxbp,:gjxbg,:gnxb,:tcsd,:tcxb,:ems,:swtd], Logistic
        can :manage, SequenceNo
        can :manage, BigPacket
        cannot :rebuild, BigPacket do |big_packet|
            !big_packet.can_rebuild?
        end
        cannot :resend, BigPacket do |big_packet|
            !big_packet.can_resend?
        end
        can :tarrif_log_report, :tarrif_logs

        can :manage, InterfaceSender, storage_id: storage.id

        cannot :resend, InterfaceSender do |interface_sender|
            (interface_sender.status == "success")
        end

        cannot :rebuild, InterfaceSender do |interface_sender|
            (interface_sender.object_class.blank? || interface_sender.object_id.blank? || interface_sender.status == "success")
        end    
    end

    if user.order?(storage)
        can :change, Storage, id: storage.id

        can :manage, Keyclientorder, storage_id: storage.id
        can :manage, Keyclientorderdetail, keyclientorder: {storage_id: storage.id}
        cannot :destroy, Keyclientorder do |keyclientorder|
            (keyclientorder.storage_id == storage.id)&& keyclientorder.has_checked?
        end
        can :manage, Order, storage_id: storage.id
        cannot :destroy, Order, status: ['spliting', 'splited', 'printed', 'picking', 'checked', 'packed', 'delivering', 'delivered', 'declined', 'returned', 'cancel', 'packeted']
        cannot :order_recover, Order, status: ['waiting','spliting','splited','printed','packed','delivering','delivered','declined','returned','cancel','packeted']
        can :manage, OrderDetail, order: {storage_id: storage.id}

        can :manage, OrderReturn, storage_id: storage.id, status: Purchase::STATUS[:opened]

        # can :new, Stock
        can :read, Stock, shelf: {area: {storage_id: storage.id} }
        can :ready2bad, Stock, shelf: {area: {storage_id: storage.id} }
        can :move2bad, Stock, shelf: {area: {storage_id: storage.id} }

        can :read, StockLog, shelf: {area: {storage_id: storage.id}}
        cannot :destroy, StockLog do |stocklog|
            if stocklog.parent.is_a? Purchase
                stocklog.parent.status == Purchase::STATUS[:closed]
            elsif stocklog.parent.is_a? ManualStock
                stocklog.parent.status == ManualStock::STATUS[:closed]
            elsif stocklog.parent.is_a? Inventory
                stocklog.parent.status == Inventory::STATUS[:closed]
            elsif stocklog.parent.is_a? MoveStock
                stocklog.parent.status == MoveStock::STATUS[:moved]
            elsif stocklog.parent.is_a? OrderReturn
                stocklog.parent.status == OrderReturn::STATUS[:checked]
            elsif stocklog.parent.is_a? Keyclientorder
                stocklog.status == StockLog::STATUS[:checked]
            else
                stocklog.status == StockLog::STATUS[:checked]
            end
        end

        can :autocomplete_specification_name, Specification, commodity: {unit_id: user.unit_id}

        can :read, Task, storage_id: storage.id
        can :destroy, Task, status: "doing"

        can [:read,:hotprint_ready,:hotprint_show,:gjxbp,:gjxbg,:gnxb,:tcsd,:tcxb,:ems,:swtd], Logistic
    end

    if user.purchase?(storage)
        can :change, Storage, id: storage.id

        can :manage, Purchase, storage_id: storage.id, status: Purchase::STATUS[:opened]

        can :manage, PurchaseDetail, purchase: {storage_id: storage.id, status: Purchase::STATUS[:opened]}

        can [:read,:stock_in], Purchase, storage_id: storage.id, status: Purchase::STATUS[:closed]

        can :read, PurchaseDetail, purchase: {storage_id: storage.id, status: Purchase::STATUS[:closed]}

        cannot :close, Purchase do |purchase|
            (purchase.storage_id == storage.id) && (purchase.status == Purchase::STATUS[:opened]) && !purchase.can_close?
        end

        cannot :destroy, Purchase do |purchase|
            (purchase.storage_id == storage.id)&& purchase.has_checked?
        end
        
        can :read, Stock, shelf: {area: {storage_id: storage.id} }

        can :read, StockLog, shelf: {area: {storage_id: storage.id}}
        cannot :destroy, StockLog do |stocklog|
            if stocklog.parent.is_a? Purchase
                stocklog.parent.status == Purchase::STATUS[:closed]
            elsif stocklog.parent.is_a? ManualStock
                stocklog.parent.status == ManualStock::STATUS[:closed]
            elsif stocklog.parent.is_a? Inventory
                stocklog.parent.status == Inventory::STATUS[:closed]
            elsif stocklog.parent.is_a? MoveStock
                stocklog.parent.status == MoveStock::STATUS[:moved]
            elsif stocklog.parent.is_a? OrderReturn
                stocklog.parent.status == OrderReturn::STATUS[:checked]
            elsif stocklog.parent.is_a? Keyclientorder
                stocklog.status == StockLog::STATUS[:checked]
            else
                stocklog.status == StockLog::STATUS[:checked]
            end
        end

        can :autocomplete_specification_name, Specification, commodity: {unit_id: user.unit_id}
        can [:read,:hotprint_ready,:hotprint_show,:gjxbp,:gjxbg,:gnxb,:tcsd,:tcxb,:ems,:swtd], Logistic
    end

    if user.packer?(storage)
        can :change, Storage, id: storage.id

        can :read, Order, storage_id: storage.id
        # can :findorderout, Order, storage_id: storage.id
        can :find_order_out, Order, storage_id: storage.id
        can :find_order_detail_out, Order, storage_id: storage.id
        can :find_cs_out, Order, storage_id: storage.id
        can :confirm_order_out, Order, storage_id: storage.id
        can :setoutstatus, Order, storage_id: storage.id
        can :packout, Order, storage_id: storage.id
        can :packaging_index, Order, storage_id: storage.id
        can :packaged_index, Order, storage_id: storage.id
        can [:read,:hotprint_ready,:hotprint_show,:gjxbp,:gjxbg,:gnxb,:tcsd,:tcxb,:ems,:swtd], Logistic
        can :manage, BigPacket
        cannot :rebuild, BigPacket do |big_packet|
            !big_packet.can_rebuild?
        end
        cannot :resend, BigPacket do |big_packet|
            !big_packet.can_resend?
        end
    end

    if user.sorter?(storage)
        can :change, Storage, id: storage.id

        can :manage, Purchase, storage_id: storage.id, status: Purchase::STATUS[:opened]

        can :manage, PurchaseDetail, purchase: {storage_id: storage.id, status: Purchase::STATUS[:opened]}

        can [:read,:stock_in], Purchase, storage_id: storage.id, status: Purchase::STATUS[:closed]

        can :read, PurchaseDetail, purchase: {storage_id: storage.id, status: Purchase::STATUS[:closed]}

        cannot :close, Purchase do |purchase|
            (purchase.storage_id == storage.id) && (purchase.status == Purchase::STATUS[:opened]) && !purchase.can_close?
        end

        cannot :destroy, Purchase do |purchase|
            (purchase.storage_id == storage.id)&& purchase.has_checked?
        end
        
        cannot :update, PurchaseDetail do |purchase_detail|
            (purchase_detail.purchase.storage_id == storage.id) && (purchase_detail.status == PurchaseDetail::STATUS[:stock_in])
        end
        
        cannot :destroy, PurchaseDetail do |purchase_detail|
            (purchase_detail.purchase.storage_id == storage.id) && (purchase_detail.status == PurchaseDetail::STATUS[:stock_in])
        end

        can :manage, ManualStock, storage_id: storage.id, status: ManualStock::STATUS[:opened]

        can :manage, ManualStockDetail, manual_stock: {storage_id: storage.id, status: ManualStock::STATUS[:opened]}

        can [:read,:stock_out], ManualStock, storage_id: storage.id, status: ManualStock::STATUS[:closed]

        can :read, ManualStockDetail, manual_stock: {storage_id: storage.id, status: ManualStock::STATUS[:closed]}

        cannot :close, ManualStock do |manual_stock|
            (manual_stock.storage_id == storage.id) && (manual_stock.status == ManualStock::STATUS[:opened]) && !manual_stock.can_close?
        end

        cannot :destroy, ManualStock do |manual_stock|
            (manual_stock.storage_id == storage.id)&& manual_stock.has_checked?
        end

        cannot :update, ManualStockDetail do |manual_stock_detail|
            (manual_stock_detail.manual_stock.storage_id == storage.id) && (manual_stock_detail.status == ManualStockDetail::STATUS[:stock_out])
        end

        cannot :destroy, ManualStockDetail do |manual_stock_detail|
            (manual_stock_detail.manual_stock.storage_id == storage.id) && (manual_stock_detail.status == ManualStockDetail::STATUS[:stock_out])
        end

        can :read, Stock, shelf: {area: {storage_id: storage.id} }
        can :ready2bad, Stock, shelf: {area: {storage_id: storage.id} }
        can :move2bad, Stock, shelf: {area: {storage_id: storage.id} }

        can :manage, MoveStock, unit_id: user.unit_id
        cannot :destroy, MoveStock do |move_stock|
            (move_stock.storage_id == storage.id)&& move_stock.has_checked?
        end

        can :read, StockLog, shelf: {area: {storage_id: storage.id}}
        cannot :destroy, StockLog do |stocklog|
            if stocklog.parent.is_a? Purchase
                stocklog.parent.status == Purchase::STATUS[:closed]
            elsif stocklog.parent.is_a? ManualStock
                stocklog.parent.status == ManualStock::STATUS[:closed]
            elsif stocklog.parent.is_a? Inventory
                stocklog.parent.status == Inventory::STATUS[:closed]
            elsif stocklog.parent.is_a? MoveStock
                stocklog.parent.status == MoveStock::STATUS[:moved]
            elsif stocklog.parent.is_a? OrderReturn
                stocklog.parent.status == OrderReturn::STATUS[:checked]
            elsif stocklog.parent.is_a? Keyclientorder
                stocklog.status == StockLog::STATUS[:checked]
            else
                stocklog.status == StockLog::STATUS[:checked]
            end
        end

        can :manage, Inventory, unit_id: user.unit_id
        cannot :destroy, Inventory do |inventory|
            (inventory.storage_id == storage.id)&& inventory.has_checked?
        end
        
        can :autocomplete_specification_name, Specification, commodity: {unit_id: user.unit_id}
        can [:read,:hotprint_ready,:hotprint_show,:gjxbp,:gjxbg,:gnxb,:tcsd,:tcxb,:ems,:swtd], Logistic
        can :manage, BigPacket
        cannot :rebuild, BigPacket do |big_packet|
            !big_packet.can_rebuild?
        end
        cannot :resend, BigPacket do |big_packet|
            !big_packet.can_resend?
        end
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
