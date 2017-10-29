require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    # usersはfixturesのusers.ymlを指す
    @user = users(:michael)
  end

  # 更新が失敗するパターン
  test 'unsuccessful edit' do
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

  # 更新が成功するパターン
  test 'successful edit' do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmmation: '',
                                            }
                                    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email,@user.email
  end

end
