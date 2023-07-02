require 'application_system_test_case'

class CartsTest < ApplicationSystemTestCase
  setup do
    @cart = carts(:one)
  end

  test 'visiting the index' do
    visit carts_url
    assert_selector 'h1', text: 'Listing carts'
  end

  test 'creating a Cart' do
    visit store_index_url

    assert_no_text 'Your Cart'
    assert_text 'MyString'
    assert_text 'MyString2'
    assert_no_selector '.line-item-highlight'
    click_on 'Add to Cart', match: :first
    assert_selector '.line-item-highlight'
    all('input[value="Add to Cart"]')[1].click
    assert_selector '.line-item-highlight'

    assert_text 'Your Cart'
    assert_text '1 MyString $9.99'
    assert_text '1 MyString2 $9.99'
    assert_text 'Total: $19.98'
  end

  test 'destroying a Cart' do
    visit store_index_url

    assert_no_text 'Your Cart'
    assert_text 'MyString'
    click_on 'Add to Cart', match: :first

    assert_text 'Your Cart'
    assert_text '1 MyString $9.99'
    assert_text 'Total: $9.99'

    accept_confirm { click_on 'Empty cart' }

    assert_no_text 'Your Cart'
    assert_no_text '1 MyString $9.99'
    assert_no_text 'Total: $9.99'
  end
end
