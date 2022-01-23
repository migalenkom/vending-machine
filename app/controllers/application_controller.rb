# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :authorise!
  delegate :allow?, to: :current_permission

  rescue_from 'ActiveRecord::RecordNotFound' do |_exception|
    not_found!
  end

  def not_found!
    render json: 'Not found', status: :not_found
  end

  private

  def authorise!
    authenticate_or_request_with_http_basic do |username, password|
      return render status: :unauthorized unless current_user(username)

      authenticated = current_user.authenticate(password)
      return render status: :forbidden unless current_permission.allow?(controller_name, action_name, current_resource)

      authenticated
    end
  end

  def current_user(username = nil)
    @current_user ||= User.find_by(username: username)
    @current_user
  end

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  # This gets overriden in each controller
  def current_resource
    nil
  end
end
