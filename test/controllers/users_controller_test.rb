require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user) # loginしないでedit画面へ遷移
    assert_not flash.empty? # flashがemptyではない = errorが格納されている
    assert_redirected_to login_url # login画面にredirect
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,       # loginしないでusers#update
                                              email: @user.email } }
    assert_not flash.empty? # flashがemptyではない = errorが格納されている
    assert_redirected_to login_url # login画面にredirect
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user) #  user2でlogin
    get edit_user_path(@user)  # loginしていない別のuserのurlでedit画面へ遷移
    assert flash.empty? # errorは格納されない
    assert_redirected_to root_url # root画面へredirect login中なのでlogin画面へはredirectしない
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user) # user2でlogin
    # loginしていない別のuserのurlでusers#update
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?  # errorは格納されない
    assert_redirected_to root_url # root画面へredirect login中なのでlogin画面へはredirectしない
  end

end
