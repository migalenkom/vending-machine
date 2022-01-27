class User < ApplicationRecord
  # fileld  :username
  # fileld  :password
  # fileld  :role
  # fileld  :deposit

  COINS = [5, 10, 20, 50, 100].freeze
  ROLES = %w[buyer seller].freeze

  has_secure_password
  validates :username, uniqueness: true
  validates :password_digest, presence: true
  validates :role, inclusion: { in: ROLES }
  has_many :products, inverse_of: :seller

  enum role: {
    buyer: 0,
    seller: 1
  }

  def change_coins
    remain = deposit
    COINS.reverse.each_with_object({}) do |coin, result|
      count = remain / coin
      result.merge!(coin => count) if count.positive?
      remain = remain % coin
    end
  end
end
