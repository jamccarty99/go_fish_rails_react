FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Test User #{n}"}
    sequence(:password) { |n| "testuser#{n}"}
    sequence(:password_confirmation) { |n| "testuser#{n}"}
  end
end
