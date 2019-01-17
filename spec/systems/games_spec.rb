require "rails_helper"

RSpec.describe 'Games', type: :system do
  let(:existing_user1) { User.create(name: 'Frank Sinatra', password: 'franky', password_confirmation: 'franky') }
  let(:player1) { User.create(name: 'Player 1', password: 'player1', password_confirmation: 'player1') }
  let(:player2) { User.create(name: 'Player 2', password: 'player2', password_confirmation: 'player2') }

  before do
    driven_by(:rack_test)
  end

  it 'requires authentication' do
    visit '/games'

    expect(page).to have_content 'Go Fish!'
    expect(current_path).to eq new_session_path
  end

  describe 'main menu' do
    before do
      visit '/'
      fill_in 'Name', with: existing_user1.name
      fill_in 'Password', with: existing_user1.password
      click_on 'Log in'
    end

    it 'allows a user to click Play Game and take them to game size page' do
      click_on 'Play Game'
      expect(page).to have_content 'Number of Players'
    end

    it 'allows a user to view the Leaderboard' do
      click_on 'Leaderboard'
      expect(page).to have_content 'High Score'
    end

    it 'allows a user to view the rules' do
      click_on 'How to Play'
      expect(page).to have_content 'OBJECT OF THE GAME'
    end

    it 'allows a user to log out' do
      click_on 'Log Out'
      expect(page).to have_content 'Log Out Successful'
      visit '/sessions'
      expect(page).to have_content 'Log in to continue'
    end

    it 'allows a user to go "back" one page' do
      find('.navigation__item--back').click
      expect(page).to have_content 'Go Fish!'
    end

    it 'allows a user to access the settings page' do
      find('.navigation__item--settings').click
      expect(page).to have_content 'Settings'
    end
  end

  describe 'multiple sessions' do
    let(:session1) { Capybara::Session.new(:selenium_chrome_headless, Rails.application) }
    let(:session2) { Capybara::Session.new(:selenium_chrome_headless, Rails.application) }
    before do
      player1
      player2
      [session1, session2].each_with_index do |session, index|
        player_name = "Player #{index + 1}"
        player_password = "player#{index +1}"
        session.visit '/'
        session.fill_in 'Name', with: player_name
        session.fill_in 'Password', with: player_password
        session.click_on 'Log in'
        session.click_on 'Play Game'
      end
    end

    it 'starts a game when enough players join' do
      session1.click_on '2 Player'
      session2.click_on '2 Player'
      expect(session2).to have_content "It is Player 1's turn"
      expect(session2).to have_content 'Cards: 7'
      session1.driver.refresh
      expect(session1).to have_content 'It is your turn'
      expect(session1).to have_content 'Cards: 7'
    end

    it 'lets the current_player make an initial request' do
      session1.click_on '2 Player'
      session2.click_on '2 Player'
      session1.driver.refresh
      session1.first('.opponent_avatar_container').click
      session1.first('.player_hand').click
      expect(session1).to have_content "It is Player 2's turn"
      expect(session1).to have_content "37"
    end

    
  end
end
