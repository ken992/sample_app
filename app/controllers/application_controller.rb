class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?  # loginしていなければ
      store_location   # accessしようとしたURLをsessionに格納
      flash[:danger] = 'Please log in.'  # messeageを格納
      redirect_to login_url   # loginへredirect
    end
  end

end
