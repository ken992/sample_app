require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    # usersはfixturesのusers.ymlを指す
    @user = users(:michael)
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
    log_in_as(@user)  # test user で login
    assert_redirected_to edit_user_url(@user) # edit画面にredirect
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
