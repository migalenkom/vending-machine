class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :role, :deposit, :created_at, :updated_at
end
