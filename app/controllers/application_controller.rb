class ApplicationController < ActionController::Base
    include Pundit::Authorization
    include Pagy::Backend
    before_action :authenticate_user!
    rescue_from Pagy::OverflowError, with: :redirect_to_valid_page

    private
  
    def redirect_to_valid_page(exception)
      redirect_to request.path + "?page=#{exception.pagy.last}"
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
