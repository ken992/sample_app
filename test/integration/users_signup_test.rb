require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "",
                                         password:              "a111",
                                         password_confirmation: "111" } }
    end
    assert_template 'users/new'
    assert_template 'shared/_error_messages'
    assert_template 'layouts/_rails_default'

    assert_select "div" , /The form contains/
    assert_select "div" , /The form contains [1-6] error/
    assert_select "div#error_explanation li" , 1..6 
    assert_select 'form[action="/signup"]'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_select   "div" , /Welcome to the Sample App/
    assert_select   "div.alert-success" , "Welcome to the Sample App!"
    assert_not flash.empty?
    assert flash.present?
  end

end
