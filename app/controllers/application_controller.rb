# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :authorise!

  rescue_from 'ActiveRecord::RecordNotFound' do |exception|
    error!(exception.message, :not_found)
  end

  rescue_from ActionController::ParameterMissing do |exception|
    error!(exception.message)
  end

  private

  delegate :allow?, to: :current_permission
  attr_reader :current_user

  def error!(errors, status = :unprocessable_entity)
    render json: errors, status: status
  end

  def authorise!
    authenticate_or_request_with_http_basic do |username, password|
      @current_user ||= User.find_by(username: username)
      return render status: :unauthorized unless current_user

      authenticated = current_user.authenticate(password)
      unless current_permission.allow?(controller_name, action_name, current_resource)
        return error!('No access', :forbidden)
      end

      authenticated
    end
  end

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  # This gets overriden in each controller
  def current_resource; end
end
