class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user2 = params[:id]
  end

  def new
  end
end
