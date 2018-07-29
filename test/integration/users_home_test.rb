require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "home count relationships" do
    get root_path(@user)

    assert_match @user.following.count.to_s, response.body
    assert_match @user.followers.count.to_s, response.body

  end
end
