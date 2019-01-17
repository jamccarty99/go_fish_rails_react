require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#name' do
    before do
      @user = User.new(name: "Example User", password: "foobar", password_confirmation: "foobar")
    end

    it 'is required' do
      @user.name = ""
      expect(@user.valid?).not_to be(true)
    end

    it "should be valid" do
      expect(@user.valid?).to be(true)
    end

    it "name should be present" do
      @user.name = "     "
      expect(@user.valid?).to_not be(true)
    end

     it "name should not be too long" do
      @user.name = "a" * 51
      expect(@user.valid?).to_not be(true)
    end

    # it 'must be unique' do
    #   @user
    #   new_user = User.new(name: "Example User", password: "foobar", password_confirmation: "foobar")
    #
    #   expect(new_user.valid?).not_to be(true)
    #   expect {
    #     new_user.save!
    #   }.to raise_error ActiveRecord::RecordInvalid
    # end
  end

  describe '#password' do
    before do
      @user = User.new(name: "Example User", password: "foobar", password_confirmation: "foobar")
    end

    it "password should be present (nonblank)" do
      @user.password = @user.password_confirmation = " " * 6
      expect(@user.valid?).to be(false)
    end

    it "password should have a minimum length" do
      @user.password = @user.password_confirmation = "a" * 5
      expect(@user.valid?).to be(false)
    end
  end

  # describe '#user record' do
  #   let(:user1) { create(:user) }
  #   let(:user2) { create(:user) }
  #   let!(:lost_game) { create(:game, users: [user1, user2], winner: user2) }
  #   let!(:won_game1) { create(:game, users: [user1, user2], winner: user1) }
  #   let!(:won_game2) { create(:game, users: [user1, user2], winner: user1) }
  #
  #   it 'returns the games a user has won' do
  #     expect(user1.won_games).to eq [ won_game1, won_game2 ]
  #     expect(user2.won_games).to eq [ lost_game ]
  #   end
  #
  #   it 'handle a user that has no games' do
  #     user = create(:user)
  #     expect(user.winning_percentage).to eq 0
  #
  #   end
  #   it 'calculates the winning percentage for the user' do
  #     expect(user1.winning_percentage).to be_within(0.001).of 0.666
  #     expect(user2.winning_percentage).to be_within(0.001).of 0.333
  #   end
  #
  #   it 'returns a human readable pecentage' do
  #     expect(user1.winning_percentage_string).to eq '67%'
  #     expect(user2.winning_percentage_string).to eq '33%'
  #   end
  # end
end
