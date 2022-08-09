FactoryBot.define do
  factory :feedback do
    owner_id { rand(1..10_000) }
    comment { Faker::Lorem.sentence }
  end
end
