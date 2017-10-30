require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    # usersはfixturesのusers.ymlを指す
    @user = users(:michael)
    @other_user = users(:archer)
  end

  # 更新が失敗するパターン
  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmmation: 'bar',
                                            }
                                    }
    assert_template 'users/edit'
    assert_select 'div' , /The form contains [3-3] error/
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
                                              password_confirmmation: '',
                                            }
                                    }
    assert_not flash.empty? # flashに'Profile updated'
    assert_redirected_to @user # update successのためshow画面へ遷移
    # DBの状態がpatchした内容と同じ確認
    @user.reload
    assert_equal name, @user.name
    assert_equal email,@user.email
  end

end
