require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @order = orders(:one)
  end

  test 'should get index' do
    login_as users(:dave)
    get orders_url
    assert_response :success
  end

  test 'require item in cart' do
    get new_order_url
    assert_redirected_to store_index_path
    assert_equal flash[:notice], 'Your cart is empty.'
  end

  test 'should get new' do
    post line_items_url, params: { product_id: products(:ruby).id }

    get new_order_url
    assert_response :success
  end

  test 'should create order' do
    assert_difference('Order.count') do
      post orders_url, params: { order: { address: @order.address,
                                          email: @order.email,
                                          name: @order.name,
                                          pay_type: @order.pay_type } }
    end

    assert_redirected_to store_index_url(locale: :en)
  end

  test 'should show order' do
    get order_url(@order)
    assert_response :success
  end

  test 'should get edit' do
    login_as users(:dave)
    get edit_order_url(@order)
    assert_response :success
  end

  test 'should not send email when not updating order`s ship_date' do
    login_as users(:dave)
    assert_difference('ActionMailer::Base.deliveries.count', 0) do
      perform_enqueued_jobs do
        patch order_url(@order), params: { order: { address: @order.address,
                                                    email: @order.email,
                                                    name: @order.name,
                                                    pay_type: @order.pay_type } }
      end
    end

    assert_redirected_to order_url(@order)
  end

  test 'should send email when updating order`s ship_date' do
    login_as users(:dave)
    assert_difference('ActionMailer::Base.deliveries.count', 1) do
      perform_enqueued_jobs do
        patch order_url(@order), params: { order: { address: @order.address,
                                                    email: @order.email,
                                                    name: @order.name,
                                                    pay_type: @order.pay_type,
                                                    ship_date: 7.days.from_now } }
      end
    end

    assert_redirected_to order_url(@order)

    mail = ActionMailer::Base.deliveries.last
    assert_equal 'Pragmatic Store Order Shipped', mail.subject
  end

  test 'should destroy order' do
    login_as users(:dave)
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
