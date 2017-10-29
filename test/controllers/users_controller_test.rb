require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user) # loginしないでedit画面へ遷移
    assert_not flash.empty? # flashがemptyではない = errorが格納されている
    assert_redirected_to login_url # login画面に転送される
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,       # loginしないでusers#update
                                              email: @user.email } }
    assert_not flash.empty? # flashがemptyではない = errorが格納されている
    assert_redirected_to login_url # login画面に転送される
  end
end
