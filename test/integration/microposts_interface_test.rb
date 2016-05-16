require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:mahmoud)
  end

  test "micropost interface" do
    log_in_as @user
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path , micropost: { content: '' }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "test test"
    picture = fixture_file_upload('test/fixtures/test.png', 'image/png')
    assert_difference 'Micropost.count' , 1 do
      post microposts_path , micropost: { content: content , picture: picture }
    end
    assert assigns(:micropost).picture?
    
    assert_redirected_to root_path
    follow_redirect!
    assert_match content , response.body
    # delete a micropost
    assert_select 'a' , text: 'delete'
    micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count' , -1 do
      delete micropost_path(micropost)
    end
    # different user profile
    get user_path(users(:ahmed))
    assert_select 'a' , text: 'delete' , count: 0
  end

end
