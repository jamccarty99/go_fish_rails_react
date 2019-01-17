FactoryBot.define do
  factory :game do
    game_size { 2 }
    
    trait :started do
      started_at { Time.zone.now }
    end

    trait :finished do
      started_at { 5.minutes.ago }
      finished_at { Time.zone.now }
    end

    trait :winner do
      winner { 'Player 1' }
    end

  end
end
