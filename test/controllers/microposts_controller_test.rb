require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  def setup
    @micropost = microposts(:one)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create , micropost: { content: 'test test' }
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete :destroy , id: @micropost
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when wrong user" do
    log_in_as(users(:mahmoud))
    micropost = microposts(:dogs)
    assert_no_difference 'Micropost.count' do
      delete :destroy , id: micropost
    end
    assert_redirected_to root_path
  end

end
