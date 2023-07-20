ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :firstname, :lastname, :image, :type, :phone_number, :DOB, :department, :email, :reportingmanager
  # or
  form do |f|
    f.inputs "User Details" do
      f.input :firstname
      f.input :lastname
      f.input :email
      f.input :image
      f.input :type
      f.input :phone_number
      f.input :DOB
      f.input :department
      f.input :reportingmanager
    end
    f.actions
  end
  # permit_params do
  #   permitted = [:firstname, :lastname, :image, :type, :phone_number, :DOB, :department, :email, :reportingmanager]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
