require "rails_helper"

RSpec.describe 'Sign Up', type: :system do
  before do
    driven_by(:rack_test)
    @existing_user = User.create(name: 'Frank Sinatra', password: 'franky', password_confirmation: 'franky')
  end

  it 'allows a new user to sign up' do
    visit '/users/new'

    expect {
      fill_in 'Name', with: 'Joey'
      fill_in 'Password', with: 'joeyjo'
      fill_in 'Password Confirmation', with: 'joeyjo'
      click_on 'Sign Up'
    }.to change(User, :count).by(1)

    expect(page).to have_content 'Welcome'
  end

  it 'allows an existing user to login' do
    visit '/'

    expect {
      fill_in 'Name', with: @existing_user.name
      fill_in 'Password', with: @existing_user.password
      click_on 'Log in'
    }.not_to change(User, :count)

    expect(page).to have_content 'Welcome'
  end

  it 'prevents login for blank name' do
    visit '/'

    # don't fill in name
    fill_in 'Password', with: @existing_user.password
    click_on 'Log in'

    expect(page).to have_content 'Invalid name/password'
  end

  it 'prevents login for blank password' do
    visit '/'

    # don't fill in name
    fill_in 'Password', with: @existing_user.password
    click_on 'Log in'

    expect(page).to have_content 'Invalid name/password'
  end
end
