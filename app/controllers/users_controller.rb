class UsersController < ApplicationController
  before_action :get_user, only: %i[edit update]

  def new
    @user = User.new
    render 'new'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:alert] = @user.errors.full_messages.join(', ')
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to root_path
    else
      flash.now[:alert] = @user.errors.full_messages.join(', ')
      render 'edit'
    end
  end

  private

  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :email, :username)
  end
end
