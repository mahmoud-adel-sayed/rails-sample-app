require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:mahmoud)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user) , user: { name: "" , email: "test@invalid" , password: "123" , password_confirmation: "12"}
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "mamoud adel"
    email = "test@gmail.com"
    patch user_path(@user) , user: { name: name , email: email , password: "" , password_confirmation: ""}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.email , email
    assert_equal @user.name , name
  end
end
