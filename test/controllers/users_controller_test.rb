require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'should redirect index when not logged in' do
    # 未loginでusers indexにaccsessするとlogin画面にredirect
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

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user) # user2でlogin
    # loginしていない別のuserのurlでusers#update
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?  # errorは格納されない
    assert_redirected_to root_url # root画面へredirect login中なのでlogin画面へはredirectしない
  end

  test 'should not allow the admin attribute to be edited via the web' do
    log_in_as(@other_user) # user2でlogin
    assert_not @other_user.admin? # user2はadmin権限を持っていない
    patch user_path(@other_user), params: { user: { password: @other_user.password,
                                                    name: "aaaaaa",
                                                    password_confirmation: @other_user.password_confirmation,
                                                    admin: true } }  # admin権限を付与

    assert_not @other_user.reload.admin? # reloadしたuser2はadmin権限を持っていない
                                                  # reloadしないと@otherの内容は更新されない

    patch user_path(@other_user), params: { user: { name: "aaaaaa" } }  # nameの変更
    @other_user.reload
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
