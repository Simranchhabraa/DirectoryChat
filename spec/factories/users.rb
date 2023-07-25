FactoryBot.define do
    factory :user do
      firstname { Faker::Name.first_name }
      lastname { Faker::Name.last_name }
      image { nil }
      phone_number { Faker::PhoneNumber.phone_number }
      DOB { Faker::Date.birthday }
      department { nil }
      email { Faker::Internet.email }
      reportingmanager { nil }
      password { "123456" }
      password_confirmation {"123456"}
    end
  end