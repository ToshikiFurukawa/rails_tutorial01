class PasswordResetsController < ApplicationController
  before_action :got_user,   only:[:edit, :update]
  before_action :valid_user, only:[:edit, :update]
  before_action :cehck_exporation, only:[:edit, :update]
  def new
  end

  def create
      @user = User.find_by(email:params[:password_reset][:email].downcase)
      if @user
        @user.create_reset_digest
        @user.send_password_reset_email
        flash[:info] = "Email sent with password reset instructions"
        redirect_to root_url
      else
        flash.now[:danger] = "Email address not found"
        render 'new'
      end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.error.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attribute(user_params)
      log_in @user_params
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end


  private

  def user_params
    params.require(:user).permit(:password,:password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless(@user && @user.activated? && @user.authenticated?(:reset,params[:id]))
      redirect_to root_url
    end
  end

  def check_expriration
    if@user.password_reset_expired?
      flash[:danger] = "Password reset has wxpiesd."
      redirect_to new_password_reset_url
    end
  end
end
