ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module AuthenticationHelpers
  def login_as(user)
    if respond_to? :visit
      visit login_url
      fill_in :name, with: user.name
      fill_in :password, with: 'secret'
      click_on 'Login'
    else
      post login_url, params: { name: user.name, password: 'secret' }
    end
  end

  def login_as_and_visit(user, url)
    return unless respond_to? :visit

    login_as user
    visit url
  end

  def logout
    delete logout_url
  end
end

module ActionDispatch
  class IntegrationTest
    include AuthenticationHelpers
  end

  class SystemTestCase
    include AuthenticationHelpers
  end
end
