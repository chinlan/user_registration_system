class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:user][:email])
    if user
      user.generate_password_token!
      UserMailer.reset_password(user).deliver_later
    end
    flash[:notice] = "The reset password email is sent!"
    redirect_to root_path
  end

  def edit
    unless @user&.reset_password_token_expires_at && @user.reset_password_token_expires_at > Time.now
      flash[:alert] = 'The link is expired!'
      redirect_to root_path
    end
  end

  def update
    if @user.update(password_params)
      @user.clear_password_token!
      flash[:notice] = "The password is reset!"
      redirect_to login_path
    else
      flash.now[:alert] = @user.errors.full_messages.join(', ')
      render 'edit'
    end
  end

  private

  def get_user
    @user = User.find_by(reset_password_token: params[:id])
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
