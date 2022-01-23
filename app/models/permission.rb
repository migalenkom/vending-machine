# frozen_string_literal: true

# Permissions class that statically keeps all controllers and actions
# that are allowed by each person type.
class Permission
  def initialize(current_user)
    guest_permissions

    # Guard condition to require a user for everything below this line
    return unless current_user

    buyer_permissions(current_user)
    seller_permissions(current_user) if current_user.seller?
  end

  def guest_permissions
    allow :users, %i[create]
  end

  # Base permissions buyers
  def buyer_permissions(current_user)
    deny  :users, %i[create]
    allow :users, %i[update destroy deposit reset profile] do |resource|
      current_user&.id == resource&.id
    end
    allow :products, %i[show index buy]
  end

  def seller_permissions(current_user)
    allow :products, %i[create]
    allow :products, %i[destroy update] do |resource|
      current_user.id == resource.seller&.id
    end
  end

  #
  # LOGIC
  #

  def allow?(controller, action, resource = nil)
    allowed = (@allow_all && !@denied_actions&.[]([controller.to_s, action.to_s])) || @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || allowed.call(resource))
  end

  def allow_all
    @allow_all = true
  end

  def allow(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
        # If we already have deny permission we need to remove it from denied
        @denied_actions&.delete([controller.to_s, action.to_s]) if @allowed_actions[[controller.to_s, action.to_s]]
      end
    end
  end

  def deny(controllers, actions, &block)
    @denied_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @denied_actions[[controller.to_s, action.to_s]] = block || true
        # If we already have allowed permissions we need to remove it from allowed
        @allowed_actions&.delete([controller.to_s, action.to_s]) if @denied_actions[[controller.to_s, action.to_s]]
      end
    end
  end
end
