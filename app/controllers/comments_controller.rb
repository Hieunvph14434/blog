class CommentsController < ApplicationController
  before_action :set_post, only: [:create]

  def create
    @comment = @post.comments.build(comment_params) 
    @comment.user = current_user                     
    @comment.parent_id = params[:parent_id] if params[:parent_id]

    if @comment.save
      flash[:notice] = "Comment was successfully created."
    else
      flash[:alert] = "There was an error creating the comment."
    end

    redirect_to @post
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content,:parent_id)
  end
end
