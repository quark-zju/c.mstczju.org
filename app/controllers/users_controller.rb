# coding: utf-8

class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  # before_filter :admin_user, :only => :destroy

  def index
    @title = "用户列表"
    @users = User.paginate(:page => params[:page])
  end

  #def new
  #  @title = "Sign up"
  #  @user = User.new
  #end

  def show
    @user = User.find(params[:id])
    # TODO show recent submits
    # @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  #def create
  #  @user = User.new(params[:user])
  #  if @user.save
  #    sign_in @user
  #    # success save
  #    flash[:success] = "Welcome to the Sample App!"
  #    redirect_to @user
  #  else
  #    @title = 'Sign up again'
  #    render 'new'
  #  end
  #end

  def edit
    @title = "编辑个人资料"
  end

  def update
    @title = "编辑个人资料"
    # check password
    user_params = params[:user]
    verify_password = user_params[:verify_password]
    if not @user.has_password?(verify_password) then
      flash[:error] = "旧密码不正确"
      render 'edit'
      return
    else
      if user_params[:password].empty? and user_params[:password_confirmation].empty?
        user_params[:password_confirmation] = verify_password
        user_params[:password] = verify_password
      end
    end

    # prevent these fields being updated
    [:name, :group, :email, :next_submit_time].each do |k|
      user_params.delete k if user_params.has_key? k
    end

    if @user.update_attributes(user_params)
      flash[:success] = "个人资料更新成功"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  #def destroy
  #  User.find(params[:id]).destroy
  #  flash[:success] = "User destroyed."
  #  redirect_to users_path
  #end

  private

  # moved to session helper
  #def authenticate
  #  deny_access unless signed_in?
  #end

  def correct_user
    @user = User.find(params[:id])
    if not current_user?(@user)
      flash[:error] = "您无权访问该页"
      redirect_to(root_path)
    end
  end

  #def admin_user
  #  redirect_to(root_path) unless current_user.admin?
  #end

end
