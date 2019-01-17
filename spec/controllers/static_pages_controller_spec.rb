require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #game_size" do
    it "returns http success" do
      get :game_size
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #rule" do
    it "returns http success" do
      get :rule
      expect(response).to have_http_status(:success)
    end
  end

  # describe "GET #game" do
  #   it "returns http success" do
  #     get :game
  #     expect(response).to have_http_status(:success)
  #   end
  # end

end
