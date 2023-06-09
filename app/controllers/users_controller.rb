# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    return unless (@user == current_user) || current_user.admin?

    @user.destroy
    redirect_to root_path, status: :see_other
  end
end
