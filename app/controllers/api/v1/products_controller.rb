# frozen_string_literal: true

# CRUD controller for Products
class Api::V1::ProductsController < ApplicationController
  def index
    products = Product.all.includes(:seller).limit(params[:limit] || 10).offset(params[:offset] || 0)
    render json: products, each_serializer: ProductSerializer
  end

  def create
    product = Product.new(product_params.merge(seller: current_user))
    if product.save
      render json: product, serializer: ProductSerializer, status: :created
    else
      error!(product.errors.full_messages, :bad_request)
    end
  end

  def update
    if current_resource.update(product_params)
      render json: current_resource, serializer: ProductSerializer
    else
      error!(product.errors.full_messages, :bad_request)
    end
  end

  def show
    render json: current_resource, serializer: ProductSerializer
  end

  def destroy
    current_resource.destroy
    render status: :no_content
  end

  def buy
    purchse = Purchase.new(product: current_resource, user: current_user, amount: params[:amount])

    if purchse.save
      render json: purchse, serializer: PurchaseSerializer
    else
      error!(purchse.errors.full_messages, :bad_request)
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :amount, :cost)
  end

  def current_resource
    @current_resource ||= Product.find(params[:id]) if params[:id]
  end
end
