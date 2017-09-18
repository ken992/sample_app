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
#    assert_select 'div.<CSS class for field with error>'

  end
end
