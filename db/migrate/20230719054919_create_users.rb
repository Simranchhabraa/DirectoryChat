class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :image
      t.string :type
      t.integer :phone_number
      t.date :DOB
      t.string :department
      t.string :email
      t.string :reportingmanager
      t.string :encrypted_password, null: false, default: ""
      t.timestamps
    end
  end
end
