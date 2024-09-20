class ApplicationController < ActionController::Base
    include Pagy::Backend
    rescue_from Pagy::OverflowError, with: :redirect_to_valid_page

    private
  
    def redirect_to_valid_page(exception)
      redirect_to request.path + "?page=#{exception.pagy.last}"
    end
end
