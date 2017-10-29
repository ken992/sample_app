require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    # usersはfixturesのusers.ymlを指す
    @user = users(:michael)
  end

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
  end

end
