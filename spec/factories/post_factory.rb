FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph(sentence_count: (5..10).to_a.sample) }
    author_ip { Faker::Internet.public_ip_v4_address }
    association :author, factory: :user
  end
end
