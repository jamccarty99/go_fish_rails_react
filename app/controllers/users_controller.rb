class UsersController < ApplicationController
  skip_before_action :require_authentication, only: [:new, :create]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def index
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:current_user] = @user.id
      session[:user_name] = @user.name
      redirect_to sessions_path, notice: 'Welcome to Go Fish!'
    else
      flash.now[:alert] = 'Please correctly fill in the fields'
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
