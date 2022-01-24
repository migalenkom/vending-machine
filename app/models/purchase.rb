class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :product

  before_validation :set_price
  validates_numericality_of :amount, greater_than: 0
  validates_numericality_of :price, greater_than: 0
  validate :check_deposit
  validate :check_product_amount
  after_create :charge_user_deposit, :charge_product_amount

  def total
    amount * price
  end

  private

  def check_deposit
    return unless user.deposit < total

    errors.add(:deposit, 'not enough')
  end

  def check_product_amount
    return unless product.amount < amount

    errors.add(:amount, 'not enough')
  end

  def charge_user_deposit
    user.increment!(:deposit, -1 * total)
  end

  def charge_product_amount
    product.increment!(:amount, -1 * amount)
  end

  def set_price
    self.price = product.cost || 0
  end
end
