class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user2 = params[:action]
  end

  def new
    @user = User.new
  end
end
