# coding: utf-8

module SessionsHelper

  def sign_in(user)
    # permanent : 20.years.from_now
    # signed: secure
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    # let 'current_user' accessible in controllers and views
    current_user = user
  end

  def sign_out
    cookies.delete :remember_token
    current_user = nil
  end

  def signed_in?
    !current_user.nil?
  end

  def is_admin?(user = nil)
    user ||= current_user
    user.group =~ /\badmin\b/ if user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_user?(user)
    user == current_user
  end 

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    # redirect_to and set flash[:notice]
    redirect_to signin_path, :notice => "登录后才能访问此页"
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    # replace one nil to [nil, nil]
    cookies.signed[:remember_token] || [nil, nil]
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
