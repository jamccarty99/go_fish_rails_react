class StaticPagesController < ApplicationController
  skip_before_action :require_authentication

  def size
  end

  def rule
  end

  def game
  end

  def waiting
  end

  def Leaderboard
  end
  
end
