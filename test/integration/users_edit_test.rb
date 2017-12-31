require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    # usersはfixturesのusers.ymlを指す
    @user = users(:michael)
    @other_user = users(:archer)
    @non_activated_user = users(:non_activated)
  end

  # 更新が失敗するパターン
  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar',
                                            }
                                    }
    assert_template 'users/edit'
    assert_select 'div' , /The form contains [0-9] error/
  end


  # friendly forwardingしてからeditがsuccessするpattern
  # friendly forwardingとは・・ユーザーが認証前に開こうとしていたページへ、認証後にリダイレクトさせること
  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user) # 未loginでedit画面にaccess
    assert_redirected_to login_url # login画面にredirect
    assert session[:forwarding_url]
    log_in_as(@user)  # test user で login
    assert_redirected_to edit_user_path(@user) # friendly forwarding
    assert_nil session[:forwarding_url] # login したら:forwarding_urlはnil

    # 続けてloginした場合,show画面へ遷移
    log_in_as(@user)
    assert_redirected_to (@user)

    # 別のuserのedit画面のurlを指定するとrootへ遷移
    get edit_user_path(@other_user)
    assert_redirected_to  root_url

    get edit_user_path(@user) # edit画面にaccess
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '',
                                            }
                                    }
    assert_not flash.empty? # flashに'Profile updated'
    assert_redirected_to @user # update successのためshow画面へ遷移
    # DBの状態がpatchした内容と同じ確認
    @user.reload
    assert_equal name, @user.name
    assert_equal email,@user.email
  end

    test 'should not allow the not activated attribute' do
    # activateしていないuserはindex画面に表示しない。
    # また、show画面にも遷移せず、rootへredirectする。

    # activateしていないuserでloginを試みる
    log_in_as(@non_activated_user)
    # activatedのカラムがfalseのままであること
    assert_not @non_activated_user.activated?
    # indexへ遷移
    get users_path
    # index画面にactivateしていないuserが表示されない
    assert_select "a[href=?]", user_path(@non_activated_user), count: 0
    # activateしていないｕｓerでshow画面へ遷移を試みる
    get user_path(@non_activated_user)
    # (show画面ではなく)rootへredirectされる
    assert_redirected_to root_url
  end

end
