require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:mahmoud)
    @non_admin = users(:ahmed)
  end

  test "index as admin with pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]' , user_path(user) , text: user.name
      unless user == @admin
        assert_select 'a[href=?]' , user_path(user) , text: "Delete" , method: :delete
      end
    end
    assert_difference 'User.count' , -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a' , text: "Delete" , count: 0
  end

end
