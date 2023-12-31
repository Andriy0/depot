require 'application_system_test_case'

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @order = orders(:one)
  end

  test 'visiting the index' do
    login_as_and_visit users(:dave), orders_url
    assert_selector 'h1', text: 'Listing orders'
  end

  test 'destroying a Order' do
    login_as_and_visit users(:dave), orders_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Order was successfully destroyed'
  end

  test 'check routing number' do
    visit store_index_url

    click_on 'Add to Cart', match: :first

    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector '#order_routing_number'

    select 'Check', from: 'order_pay_type'

    assert_selector '#order_routing_number'

    fill_in 'Routing #', with: '123'
    fill_in 'Account #', with: '987654'

    assert_difference('Order.count', 1) do
      perform_enqueued_jobs do
        click_button 'Place Order'
      end
    end

    assert_equal 3, Order.count

    order = Order.last

    assert_equal 'Dave Thomas', order.name
    assert_equal '123 Main Street', order.address
    assert_equal 'dave@example.com', order.email
    assert_equal 'Check', order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal ['dave@example.com'], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal 'Pragmatic Store Order Payment Failed', mail.subject
  end

  test 'check credit card number' do
    visit store_index_url

    click_on 'Add to Cart', match: :first

    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector '#order_credit_card_number'

    select 'Credit card', from: 'order_pay_type'

    assert_selector '#order_credit_card_number'
  end

  test 'check po number' do
    visit store_index_url

    click_on 'Add to Cart', match: :first

    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector '#order_po_number'

    select 'Purchase order', from: 'order_pay_type'

    assert_selector '#order_po_number'

    fill_in 'order_po_number', with: '987654'

    assert_difference('Order.count', 1) do
      perform_enqueued_jobs do
        click_button 'Place Order'
      end
    end

    assert_equal 3, Order.count

    order = Order.last

    assert_equal 'Dave Thomas', order.name
    assert_equal '123 Main Street', order.address
    assert_equal 'dave@example.com', order.email
    assert_equal 'Purchase order', order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal ['dave@example.com'], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal 'Pragmatic Store Order Confirmation', mail.subject
  end
end
