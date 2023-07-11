require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    login_as users(:dave)
    get admin_url
    assert_response :success
  end
end
