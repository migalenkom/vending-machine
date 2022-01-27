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
      error!(user.errors.full_messages, :bad_request)
    end
  end

  def profile
    render json: current_user, serializer: UserSerializer
  end

  def deposit
    return error!('Wrong coin') unless User::COINS.include?(params[:coin].to_i)

    current_user.increment!(:deposit, params[:coin].to_i)
    render json: current_user, serializer: UserSerializer
  end

  def reset
    current_user.update(deposit: 0)
    render json: { deposit: current_user.deposit }
  end

  def update
    if current_user.update(user_params)
      render json: current_user, serializer: UserSerializer
    else
      error!(current_user.errors.full_messages, :bad_request)
    end
  end

  def destroy
    current_user.destroy
    render status: :no_content
  end

  private

  alias current_resource current_user

  def user_params
    params.require(:user).permit(:username, :password, :role)
  end
end
