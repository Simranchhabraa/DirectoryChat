json.extract! user, :id, :firstname, :lastname, :image, :type, :phone_number, :DOB, :department, :email, :reportingmanager, :created_at, :updated_at
json.url user_url(user, format: :json)
