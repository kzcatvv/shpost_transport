class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from Exception, with: :get_errors if Rails.env.production?

  rescue_from CanCan::AccessDenied, with: :access_denied if Rails.env.production?

  protect_from_forgery with: :exception

  before_filter :configure_charsets
  before_filter :authenticate_user!

  def self.user_logs_filter *args
    after_filter args.first.select{|k,v| k == :only || k == :expert} do |controller|
      save_user_log args.first.reject{|k,v| k == :only || k == :expert}
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, current_storage)
  end

  def current_storage
    if !session[:current_storage].blank?
      Storage.find session[:current_storage]
    end

  end

  def configure_charsets
    headers["Content-Type"]="text/html;charset=utf-8"
  end

  def save_user_log *args
    object = eval("@#{args.first[:object].to_s}")
    
    object ||= eval("@#{controller_name.singularize}")

    operation = args.first[:operation]
    if operation.eql?"确认出库"
      if object
        if object.order_type.eql?"b2b"
          if current_storage.need_pick
            operation = "b2b二次拣货确认出库"
          else
            operation = "b2b确认出库"
          end
        else
          if object.order_type.eql?"b2c"
            if current_storage.need_pick
              operation = "电商二次拣货确认出库"
            else
              operation = "电商确认出库"
            end
          end
        end
      end
    end
    if operation.eql?"生成出库单"
      if current_storage.need_pick
        operation = "二次拣货生成出库单"
      else
        operation = "生成出库单"
      end
    end

    if operation.eql?"生成批量出库单"
      parent = eval("@#{args.first[:parent].to_s}")
      if !parent.blank?
        if parent.status.eql?"closed"
          return
        end
      end
    end

    import_type = eval("@#{args.first[:import_type].to_s}")
    if !import_type.blank?
      if import_type.eql?"back" and operation.eql?"订单导入回馈"
        operation = "面单信息回馈"
      end
      if import_type.eql?"standard" and operation.eql?"订单导入回馈"
        operation = "订单导入"
      end
    end

    finish = eval("@#{args.first[:finish].to_s}")
    # operation ||= I18n.t("action_2_operation.#{action_name}") + object.class.model_name.human.to_s

    symbol = args.first[:symbol]

    ids = eval("@#{args.first[:ids].to_s}")
    
    parent = eval("@#{args.first[:parent].to_s}")

    if finish.blank? or (!finish.blank? and finish.eql?"1")
      if !parent.blank?
         @user_log = UserLog.new(user: current_user, operation: operation, parent: parent)
      else
         @user_log = UserLog.new(user: current_user, operation: operation)
      end

      if object
        if object.errors.blank?
          @user_log.object_class = object.class.to_s
          @user_log.object_primary_key = object.id

          if symbol && object[symbol.to_sym]
            @user_log.object_symbol = object[symbol.to_sym]
          else
            @user_log.object_symbol = object.id
          end
          
          if args.first[:operation].eql? "包装出库" 
            @user_log.orders = Order.where(id: object.id)
          end
          if args.first[:operation].eql? "生成出库单" or args.first[:operation].eql? "确认出库"
            @user_log.orders = object.orders
          end
          
          @user_log.save

          if args.first[:operation].eql? "包装出库" 
            Order.where(id: object.id).update_all(out_at:@user_log.created_at)
          end
          if args.first[:operation].eql?"确认出库"
            Order.where(keyclientorder_id: object.id).update_all(out_at:@user_log.created_at)
          end
      
        end
      else
        if operation.eql? "订单导入"
            @user_log.orders = Order.where(id: ids)
            @user_log.object_symbol = symbol
        end
        @user_log.save
      end
    end
  end

  def set_product_select(objid)
      commodityid=Specification.find(objid.specification_id).commodity_id
      goodstypeid=Commodity.find(commodityid).goodstype_id
      @commodity=Commodity.find(commodityid)
      @goodstype=Goodstype.find(goodstypeid)
  end

  def set_autocom_update(objid)
      @spname=Specification.find(objid.specification_id).all_name
  end

  def self.interface_invokes_filter *args
    after_filter args.first.select{|k,v| k == :only || k == :expert} do |controller|
      interface_invoke args.first.reject{|k,v| k == :only || k == :expert}
    end
  end

  def interface_invoke *args
    object = eval("@#{args.first[:object].to_s}")
    object ||= eval("@#{controller_name.singularize}")
    business_id = object.try :business_id
    business_id ||= eval("@#{args.first[:business_id].to_s}")
    finish = eval("@#{args.first[:finish].to_s}")
    if !finish.blank? and finish.eql?"1"
      object_id = object.try :id
      object_id ||= eval("@#{args.first[:object_id].to_s}")
      other_params = eval("@#{args.first[:params].to_s}")

      action_type = nil
      if object.is_a? BigPacket
        action_type = object.try :big_packet_type
      elsif object.is_a? Order
        action_type = object.try :transport_type
      end
      action = args.first[:action].to_s
      if !action_type.blank?
        action = args.first[:action].to_s+ "_" + action_type.to_s
      end

      unit_id = current_user.try(:unit).try :id
      unit_id ||= object.try :unit_id
      unit_id ||= eval("@#{args.first[:unit_id].to_s}")
      
      storage_id = current_storage.try :id
      storage_id ||= object.try :storage_id
      storage_id ||= eval("@#{args.first[:storage_id].to_s}")

      re = InterfaceInvoke.where(model: object.try(:class).to_s, action: action).order(:priority)

      if !re.blank? and !business_id.blank?
        re = re.where(business: business_id.to_i).order(:priority)
      end
      if !re.blank?
        re.each do |r|
          theClass = r.theClass.constantize
          interface_sender = InterfaceSender.find_by(business_id: business_id, unit_id: unit_id, storage_id: storage_id, object_class: object.class.to_s, object_id: object_id, interface_code: r.interfaceSender)
          next if ! interface_sender.blank?
          body = theClass.send r.method,object
          interface_sender_args = {business_id: business_id, unit_id: unit_id, storage_id: storage_id, object_class: object.class.to_s, object_id: object_id}
          if !other_params.blank? && other_params.is_a?(Hash)
            interface_sender_args.merge!(other_params)
          end
          
          InterfaceSender.interface_sender_initialize(r.interfaceSender, body, interface_sender_args)
        end
      end
    end
  end

  def self.tarrif_invokes_filter *args
    after_filter args.first.select{|k,v| k == :only || k == :expert} do |controller|
      tarrif_invoke args.first.reject{|k,v| k == :only || k == :expert}
    end
  end

  def tarrif_invoke *args
    object = eval("@#{args.first[:object].to_s}")
    object ||= eval("@#{controller_name.singularize}")
    business_id = object.try :business_id
    business_id ||= eval("@#{args.first[:business_id].to_s}")
    finish = eval("@#{args.first[:finish].to_s}")

    if !finish.blank? and finish.eql?"1"
      if !business_id.blank?
        r = TarrifInvoke.where(model: object.try(:class).to_s, action: args.first[:action]).first
        if !r.blank?
          theClass = r.theClass.constantize
          theClass.send r.method,object
        end
      end
    end
  end

     
  private
  def access_denied exception
    @error_title = I18n.t 'errors.access_deny.title', default: 'Access Denied!'
    @error_message = I18n.t 'errors.access_deny.message', default: 'The user has no permission to vist this page'
    render template: '/errors/error_page',layout: false
  end

  def get_errors exception
    # Rails.logger.error(exception)
    Rails.logger.error("#{exception.class.name} #{exception.message}")
    exception.backtrace.each{|x| Rails.logger.error(x)}
    
    @error_title = I18n.t 'errors.get_errors.title', default: 'Get An Error!'
    @error_message = I18n.t 'errors.get_errors.message', default: 'The operation you did get an error'
    render :template => '/errors/error_page',layout: false
  end

  
end
