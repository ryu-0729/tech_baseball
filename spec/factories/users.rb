FactoryBot.define do
  factory :user do
    name { "Example" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
    activated { true }
    activated_at { "#{Time.zone.now}" }

    #有効化していないユーザー
    trait :non_activated_user do
      name { "non" }
      activated { false }
    end
  end
end