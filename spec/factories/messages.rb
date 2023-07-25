FactoryBot.define do
    factory :message do
      body { "Sample message body" }
      association :conversation
      association :user
    end
end