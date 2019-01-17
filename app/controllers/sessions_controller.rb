class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [:new, :create]

  def new
  end

  def index
  end

  def create
    @user = User.find_by(name: params[:session][:name])
    if @user && @user.authenticate(params[:session][:password])
      session[:current_user] = @user.id
      session[:user_name] = @user.name
      redirect_to sessions_path, notice: 'Log in successful'
    else
      flash.now[:alert] = 'Invalid name/password'
      render 'new'
    end
  end

  def destroy
    reset_session
    redirect_to '/', notice: 'Log Out Successful'
  end
end
