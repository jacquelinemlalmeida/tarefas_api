FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    status { 'em_andamento' }
    due_date { nil }
  end
end
