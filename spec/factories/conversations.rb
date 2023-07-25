FactoryBot.define do
    factory :conversation do
      association :sender, factory: :user
      association :recipient, factory: :user
      # association :user # Assuming there is a 'user' association in the Conversation model
    end
  end