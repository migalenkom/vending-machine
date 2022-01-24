class ProductSerializer < BaseSerializer
  attributes :name, :cost, :amount
  belongs_to :seller, serializer: UserShortSerializer
end
