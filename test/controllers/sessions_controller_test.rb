require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should prompt for login' do
    get login_url
    assert_response :success
  end

  test 'should redirect to login' do
    get products_url
    assert_redirected_to login_url
  end

  test 'should login' do
    post login_url, params: { name: 'dave', password: 'secret' }
    assert_redirected_to admin_url
    assert_equal users(:dave).id, session[:user_id]
  end

  test 'should fail login' do
    post login_url, params: { name: 'dave', password: 'wrong' }
    assert_redirected_to login_url
  end

  test 'should logout' do
    delete logout_url
    assert_redirected_to store_index_url
    assert_nil session[:user_id]
  end

  test 'should login with any credentials if no users available in db' do
    User.delete_all

    assert_difference('User.count', 1) do
      post login_url, params: { name: 'random_name', password: 'random_password' }
    end
    assert_redirected_to admin_url

    user = User.first
    assert_equal 'random_name', user.name
    assert_equal user.id, session[:user_id]
  end
end
