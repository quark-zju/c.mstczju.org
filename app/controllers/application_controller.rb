
class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

=begin
  #ActiveRecord exceptions
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found #400   

  #ActiveResource exceptions  
  #rescue_from ActiveResource::ResourceNotFound, :with => :not_found #404

  #ActionView exceptions
  rescue_from ActionView::TemplateError, :with => :not_found #500

  #ActionController exceptions
  rescue_from ActionController::RoutingError, :with => :not_found #404   

  rescue_from ActionController::UnknownController, :with => :not_found #404 

  rescue_from ActionController::MethodNotAllowed, :with => :not_found #405   

  rescue_from ActionController::InvalidAuthenticityToken, :with => :not_found #405

  rescue_from ActionController::UnknownAction, :with => :not_found #501

  # This particular exception causes all the rest to fail.... why?
  # rescue_from ActionController::MissingTemplate, :with => :not_found #404

  protected

  def not_found
    render :text => "Error", :status => 404
  end

=end
  private
end
