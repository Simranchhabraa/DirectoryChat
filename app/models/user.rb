class User < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
        ["DOB", "created_at", "department", "email", "firstname", "id", "image", "lastname", "phone_number", "reportingmanager", "type", "updated_at", "passwprd"]
    end
    devise :database_authenticatable, :registerable, :validatable
    has_many :conversations

end
