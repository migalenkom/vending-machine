class Product < ApplicationRecord
  COINBASE = 5

  # filed :amount
  # filed :cost
  # filed :name

  belongs_to :seller, class_name: 'User', foreign_key: :user_id
  validates :name, uniqueness: true, presence: true
  validates_numericality_of :amount, greater_than_or_equal_to: 0
  validate :check_cost

  private

  def check_cost
    return if cost.positive? && (cost % COINBASE).zero?

    errors.add(:cost, 'Please make sure cost is multiples by 5')
  end
end
