class SignupController < ApplicationController
  # POST /signup
  def create
    User.create!(user_params)
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end
