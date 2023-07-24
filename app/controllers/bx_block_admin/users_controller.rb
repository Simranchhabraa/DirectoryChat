module BxBlockAdmin
class UsersController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :set_user, only: %i[ show edit update destroy ]
  def index 
    @users = User.all
    users_data = @users.map do |user|
      {
        name: user.firstname,
        profile_picture: user.image,
        type: user.type
      }
    end
    render json: users_data
  end 
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { user: @user, message: "User was successfully created." }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def search_users
    query = params[:query].to_s.strip

    if query.present?
      users = User.where("firstname LIKE ? OR lastname LIKE ?", "%#{query}%", "%#{query}%")
      user_data = users.map do |user|
        {
          id: user.id,
          firstname: user.firstname,
          lastname: user.lastname,
          image: user.image,
          type: user.type,
          # phone_number: user.phone_number,
          # DOB: user.DOB,
          # department: user.department,
          # email: user.email,
          # reportingmanager: user.reportingmanager
        }
      end
      render json: user_data
    else
      render json: { error: "Search query cannot be empty" }, status: :unprocessable_entity
    end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:firstname, :lastname, :image, :phone_number, :DOB, :department, :email, :reportingmanager, :email, :password)
    end
end
end
