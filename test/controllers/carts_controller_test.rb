require 'test_helper'

class CartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cart = carts(:one)
  end

  test 'should get index' do
    get carts_url
    assert_response :success
  end

  test 'should get new' do
    get new_cart_url
    assert_response :success
  end

  test 'should create cart' do
    assert_difference('Cart.count') do
      post carts_url, params: { cart: {  } }
    end

    assert_redirected_to cart_url(Cart.last)
  end

  test 'should show current cart' do
    post line_items_url, params: { product_id: products(:ruby).id }
    @cart = Cart.find(session[:cart_id])

    get cart_url(@cart)
    assert_response :success
  end

  test 'should not show not current cart' do
    get cart_url(@cart)
    assert_redirected_to store_index_url
  end

  test 'should get edit' do
    get edit_cart_url(@cart)
    assert_response :success
  end

  test 'should update cart' do
    post line_items_url, params: { product_id: products(:ruby).id }
    @cart = Cart.find(session[:cart_id])

    patch cart_url(@cart), params: { cart: {} }
    assert_redirected_to cart_url(@cart)
  end

  test 'should destroy cart' do
    post line_items_url, params: { product_id: products(:ruby).id }
    @cart = Cart.find(session[:cart_id])

    assert_difference('Cart.count', -1) do
      delete cart_url(@cart)
    end

    assert_redirected_to store_index_url
  end

  test 'add/remove products to/from cart' do
    post line_items_url, params: { product_id: products(:ruby).id }
    post line_items_url, params: { product_id: products(:ruby).id }
    post line_items_url, params: { product_id: products(:one).id }
    post line_items_url, params: { product_id: products(:two).id }

    follow_redirect!

    assert_select 'tbody tr', 3
    assert_select 'tbody tr', "2\nProgramming Ruby 1.9\n$99.00"
    assert_select 'tbody tr', "1\nMyString\n$9.99"
    assert_select 'tbody tr', "1\nMyString2\n$9.99"
    assert_select 'tfoot tr', "Total:\n$118.98"

    delete line_item_url(LineItem.find_by(product: products(:ruby)))
    delete line_item_url(LineItem.find_by(product: products(:one)))

    follow_redirect!

    assert_select 'tbody tr', 2
    assert_select 'tbody tr', "1\nProgramming Ruby 1.9\n$49.50"
    assert_select 'tbody tr', "1\nMyString2\n$9.99"
    assert_select 'tfoot tr', "Total:\n$59.49"
  end
end
