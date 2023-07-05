require 'test_helper'

class ErrorMailerTest < ActionMailer::TestCase
  test 'invalid_record' do
    mail = ErrorMailer.invalid_record({ record_type: 'Product', record_id: 'ehe' })
    assert_equal 'Invalid record', mail.subject
    assert_equal ['admin@example.com'], mail.to
    assert_equal ['depot@example.com'], mail.from
    assert_match 'Error occured (but it was rescued)', mail.body.encoded
    assert_match 'Someone tried to access invalid or restricted Product with id ehe', mail.body.encoded
  end
end
