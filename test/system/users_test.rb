require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    login_as_and_visit users(:dave), users_url
  end

  test 'visiting the index' do
    assert_selector 'h1', text: 'Listing users'
  end

  test 'creating a User' do
    click_on 'New User'

    fill_in 'user_name', with: 'hanna'
    fill_in 'user_password', with: 'secret'
    fill_in 'user_password_confirmation', with: 'secret'
    click_on 'Create User'

    assert_text 'User hanna was successfully created'
  end

  test 'updating a User' do
    click_on 'Edit', match: :first

    fill_in 'user_name', with: 'rey'
    # TO DO: fix later
    # fill_in 'user_old_password', with: 'secret'
    # fill_in 'user_password', with: 'new_password'
    # fill_in 'user_password_confirmation', with: 'new_password'
    click_on 'Update User'

    assert_text 'User rey was successfully updated'
  end

  test 'destroying a User' do
    page.accept_confirm do
      all('a', text: 'Destroy')[1].click
    end

    assert_text 'User was successfully destroyed'
  end
end
