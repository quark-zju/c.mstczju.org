# coding: utf-8

class SessionsController < ApplicationController
  def new
    @title = "登录"
  end

  def create
    user = User.authenticate(params[:session][:name], params[:session][:password])
    if user.nil?
      # flash is used before a redirect
      # flash.now disappears with a redirect (link, etc.)
      flash.now[:error] = "用户名或者密码错误"
      @title = "登录"
      render 'new'
    else
      sign_in user
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end  
end
