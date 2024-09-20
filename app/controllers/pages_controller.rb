class PagesController < ApplicationController
  include ThumbnailableHelper

  def home
      @q = Post.ransack(params[:q])
      @pagy, @posts = pagy(@q.result(distinct: true).where(status: Post.statuses[:published]), limit: 6)
      load_thumbnails(@posts, true)
  end
end
