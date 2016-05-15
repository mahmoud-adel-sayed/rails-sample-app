require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:mahmoud)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Wrong email
    post password_resets_path , password_reset: { email: "wrong"}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Right email
    post password_resets_path , password_reset: { email: @user.email}
    assert_not_equal @user.reset_digest , @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    # reset form
    user = assigns(:user)
    # wrong email
    get edit_password_reset_path(user.reset_token , email: "wrong email")
    assert_redirected_to root_path
    # Inactive email
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token , email: user.email)
    assert_redirected_to root_path
    user.toggle!(:activated)
    # Right email , Wrong token
    get edit_password_reset_path("wrong token" , email: user.email)
    assert_redirected_to root_path
    # Valid email and token
    get edit_password_reset_path(user.reset_token , email: user.email)
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]" , user.email
    # Blank password
    patch password_reset_path(user.reset_token) , email: user.email , user: { password: "" , password_confirmation: "123" }
    assert_not flash.empty?
    assert_template "password_resets/edit"
    # Valid password
    patch password_reset_path(user.reset_token) , email: user.email , user: { password: "123456" , password_confirmation: "123456" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
