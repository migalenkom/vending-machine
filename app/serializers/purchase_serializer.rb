class PurchaseSerializer < BaseSerializer
  attributes :amount, :total, :product_name, :change

  def product_name
    object.product.name
  end

  def change
    object.user.change_coins
  end
end
