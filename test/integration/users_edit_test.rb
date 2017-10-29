require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
  #  get edit_user_path(@user)
  #  assert_template 'users/edit'


  end

end
