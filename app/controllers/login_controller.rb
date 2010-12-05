class LoginController < ApplicationController
  def login
    session[:user_id] = null

    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        redirect_to :action => 'index'
      else
        # login failed
        flash[:notice] = "Invalid user / password"
      end
    end
  end
end
