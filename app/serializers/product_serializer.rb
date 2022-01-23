class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :cost, :amount, :created_at, :updated_at
  belongs_to :seller, serializer: UserShortSerializer
end
