require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @product = products(:one)
    @title   = "The Great Book #{rand(1000)}"
  end

  test 'should get index' do
    get products_url
    assert_response :success
    assert_select 'h1', 'Products'
    assert_select 'main table tfoot a', 'New Product'
    assert_select 'main table tbody tr', 3
    assert_select 'main table tbody tr img', 3
    assert_select 'main table tbody tr a', 9
  end

  test 'should get new' do
    get new_product_url
    assert_response :success
  end

  test 'should create product' do
    assert_difference('Product.count') do
      post products_url, params: { product: { description: @product.description,
                                              image_url: @product.image_url,
                                              price: @product.price,
                                              title: @title } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test 'should show product' do
    get product_url(@product)
    assert_response :success
  end

  test 'should not show invalid product' do
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      perform_enqueued_jobs { get product_url('fake_id') }
    end

    assert_redirected_to products_url

    mail = ActionMailer::Base.deliveries.last
    assert_equal ['admin@example.com'], mail.to
    assert_equal 'Invalid record', mail.subject
    assert_match 'Someone tried to access invalid or restricted Product with id fake_id', mail.body.encoded
  end

  test 'should get edit' do
    get edit_product_url(@product)
    assert_response :success
  end

  test 'should update product' do
    patch product_url(@product), params: { product: { description: @product.description,
                                                      image_url: @product.image_url,
                                                      price: @product.price,
                                                      title: @title } }
    assert_redirected_to product_url(@product)
  end

  test 'cannot delete product in cart' do
    assert_difference('Product.count', 0) do
      delete product_url(products(:two))
    end

    assert_redirected_to products_url
  end

  test 'should destroy product' do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
