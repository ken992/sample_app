class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user2 = params[:action]
  end

  def new
  end
end
