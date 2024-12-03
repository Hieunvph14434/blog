class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
      @q = Post.ransack(params[:q])
      @pagy, @posts = pagy(@q.result(distinct: true).where(status: Post.statuses[:published]))
  end
end
