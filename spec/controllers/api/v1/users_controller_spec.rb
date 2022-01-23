# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:user) { create(:seller_user, deposit: 5) }

  describe 'GET profile' do
    it 'returns http success' do
      get profile_api_v1_users_path, headers: basic_auth(user)
      expect(response).to be_successful
    end

    it 'returns 401' do
      get profile_api_v1_users_path
      expect(response.code).to eql('401')
    end

    it 'returns 401 for non existing users' do
      get profile_api_v1_users_path, headers: basic_auth(OpenStruct.new({ username: 'test', password: 'test ' }))
      expect(response.code).to eql('401')
    end
  end

  describe 'PUT reset' do
    it 'allows reset own balance' do
      put reset_api_v1_users_path, headers: basic_auth(user)
      expect(user.reload.deposit).to eql(0)
    end
  end

  describe 'PUT deposit' do
    it 'allows charge balance with correct coin' do
      put deposit_api_v1_users_path, params: { coin: 5 }, headers: basic_auth(user)
      expect(user.reload.deposit).to eql(10)
    end

    it 'not allows charge balance with wrong coin' do
      put deposit_api_v1_users_path, params: { coin: 2 }, headers: basic_auth(user)
      expect(user.reload.deposit).to eql(5)
      expect(response.code).to eql('422')
    end
  end
end
