class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # By default, throw an exception if we're not running cancancan against the controller
  check_authorization :unless => :devise_controller?

  # By default, assume no-one can see anything
  before_filter :authenticate_user!, :dirty_response_headers

  layout :set_layout
  def set_layout
    if current_user
      'application'
    else
      'devise'
    end
  end

  def dirty_response_headers
    case request.format
    when "Mime::PDF"
      response.headers['Content-Type'] = 'application/pdf'
      response.headers['Content-Disposition'] = 'attachment; filename=temp.pdf'
    when "Mime::CSV"
      response.headers['Content-Type'] = 'text/csv'
      response.headers['Content-Disposition'] = 'attachment; filename=temp.csv'
    end
  end

end
