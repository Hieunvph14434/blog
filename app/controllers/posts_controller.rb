class PostsController < ApplicationController
  include ThumbnailableHelper
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :authorize_user!, only: %i[ edit update destroy ]
  skip_before_action :authenticate_user!, only: [:show]

  # GET /posts or /posts.json
  def index
    @pagy, @posts = pagy(current_user.posts, limit: 6)
  end

  # GET /posts/1 or /posts/1.json
  def show
      @posts = Post.where(status: Post.statuses[:published]).limit(5)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id

    respond_to do |format|
      if @post.save
        upload_cover_image
        format.html { redirect_to edit_post_path(@post), notice: "Post was successfully created." }
        format.json { render :edit, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        upload_cover_image
        format.html { redirect_to edit_post_path(@post), notice: "Post was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :cover_image, :status, :cover_img_url)
    end

    def authorize_user!
      unless @post.author_id == current_user.id
        redirect_to posts_path, alert: "You are not authorized to edit or delete this post."
      end
    end

    def upload_cover_image
      file = post_params[:cover_image]
      file_id = ENV['NO_IMAGE']
      file_url = nil
      
      if file
        service = GoogleDriveService.new
        rs_file = service.upload_file(file.path, file.original_filename, file.content_type)
        file_id = rs_file[:id]
        file_url = rs_file[:url]
      end
      
      if file_id
        @post.update(cover_image: file_id, cover_img_url: file_url)
      else
        flash[:alert] = "Failed to upload cover image."
      end
    end
end
