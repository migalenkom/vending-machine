FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "#{Faker::Name.name}#{n}" }
    password { 'SuperSecret' }

    factory :buyer_user do
      role { :buyer }
    end

    factory :seller_user do
      role { :seller }
    end
  end

  factory :product do
    sequence(:name) { |n| "#{Faker::Name.name}#{n}" }
    amount { 100 }
    cost { 5 }
  end
end
