# frozen_string_literal: true

# CRUD controller for User
class Api::V1::UsersController < ApplicationController
  skip_before_action :authorise!, only: %i[create]

  def index
    users = User.all.limit(params[:limit] || 10).offset(params[:offset] || 0)
    render json: users, each_serializer: UserSerializer
  end

  def create
    user = User.new(user_params)
    if user.save
      render status: :created, json: user, serializer: UserSerializer
    else
      render status: :bad_request, json: { error: user.errors.full_messages }
    end
  end

  def profile
    render json: current_user, serializer: UserSerializer
  end

  def deposit
    return wrong_coin! unless User::COINS.include?(params[:coin].to_i)

    current_user.increment!(:deposit, params[:coin].to_i)
    render json: { deposit: current_user.deposit }
  end

  def reset
    current_user.update(deposit: 0)
    render json: { deposit: current_user.deposit }
  end

  def update
    if current_user.update(password: user_params[:password])
      render json: current_user, serializer: UserSerializer
    else
      render status: :bad_request, json: { error: current_user.errors.full_messages }
    end
  end

  def destroy
    current_user.destroy
    render status: :no_content
  end

  private

  def current_resource
    current_user
  end

  def wrong_coin!
    render json: 'Wrong coin', status: :unprocessable_entity
  end

  def user_params
    params.require(:user).permit(:username, :password, :role)
  rescue ActionController::ParameterMissing
    render json: 'Missing user parameter', status: :unprocessable_entity
  end
end
