# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :request do
  let(:seller) { create(:seller_user) }
  let(:buyer) { create(:buyer_user) }
  let(:first_product) { create(:product, seller: seller) }
  let(:second_product) { create(:product, seller: seller) }

  describe 'POST buy' do
    it 'returns http success' do
      get api_v1_products_path, headers: basic_auth(seller)
      expect(response).to be_successful
    end

    it 'not enough deposit' do
      post buy_api_v1_product_path(first_product), params: { amount: 1 }, headers: basic_auth(buyer)
      expect(response.code).to eql('400')
      expect(response.body).to include('Deposit not enough')
    end

    it 'not enough products amount' do
      buyer.update(deposit: 5)
      first_product.update(amount: 0)
      post buy_api_v1_product_path(first_product), params: { amount: 1 }, headers: basic_auth(buyer)
      expect(response.code).to eql('400')
      expect(response.body).to include('Amount not enough')
    end

    it 'allows to buy product' do
      buyer.update(deposit: 5)
      post buy_api_v1_product_path(first_product), params: { amount: 1 }, headers: basic_auth(buyer)
      expect(response).to be_successful
      expect(buyer.reload.deposit).to eql(0)
      expect(first_product.reload.amount).to eql(99)
    end
  end

  describe 'PUT product' do
    it 'allows seller to edit product' do
      put api_v1_product_path(first_product), params: { product: { amount: 1 } }, headers: basic_auth(seller)
      expect(response).to be_successful
    end

    it 'not allows buyer to edit product' do
      put api_v1_product_path(first_product), params: { product: { amount: 1 } }, headers: basic_auth(buyer)
      expect(response.code).to eql('403')
    end
  end
end
