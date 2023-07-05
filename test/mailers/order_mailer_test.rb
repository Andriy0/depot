require 'test_helper'
require 'ostruct'

class OrderMailerTest < ActionMailer::TestCase
  test 'received' do
    mail = OrderMailer.received orders(:one)
    assert_equal 'Pragmatic Store Order Confirmation', mail.subject
    assert_equal ['dave@example.org'], mail.to
    assert_equal ['depot@example.com'], mail.from
    assert_match(/1 x MyString2/, mail.body.encoded)
  end

  test 'shipped' do
    mail = OrderMailer.shipped orders(:one)
    assert_equal 'Pragmatic Store Order Shipped', mail.subject
    assert_equal ['dave@example.org'], mail.to
    assert_equal ['depot@example.com'], mail.from
    assert_match %r{<td[^>]*>1</td>\s*<td>MyString2</td>}, mail.body.encoded
  end

  test 'payment failed' do
    mail = OrderMailer.payment_failed orders(:one),
                                      { routing: 123, account: 321 },
                                      OpenStruct.new(succeeded?: false, error: 'Routing number cannot be 123!')

    assert_equal 'Pragmatic Store Order Payment Failed', mail.subject
    assert_equal ['dave@example.org'], mail.to
    assert_equal ['depot@example.com'], mail.from
    assert_match 'Your payment has failed', mail.body.encoded
    assert_match 'Payment method: Check', mail.body.encoded
    assert_match 'Payment details: {:routing=&gt;123, :account=&gt;321}', mail.body.encoded
    assert_match 'Payment result: #&lt;OpenStruct succeeded?=false, error=&quot;' \
                 'Routing number cannot be 123!&quot;&gt;',
                 mail.body.encoded
  end
end
