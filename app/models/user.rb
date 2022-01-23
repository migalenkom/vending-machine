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
  validates_inclusion_of :role, in: ROLES

  enum role: {
    buyer: 0,
    seller: 1
  }

  def change_coins
    remain = deposit
    COINS.reverse.inject({}) do |result, coin|
      count = remain / coin
      result.merge!(coin => count) if count.positive?
      remain = remain % coin
      result
    end
  end
end
