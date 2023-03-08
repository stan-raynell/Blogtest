class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params.merge(
      commenter: current_user.email, user: current_user,
    ))
    redirect_to @article
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    if @comment.user == current_user or current_user.admin?
      @comment.destroy
      redirect_to @article, status: :see_other
    else
      flash[:danger] = "This is not your comment!"
      redirect_to @article
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body, :status, :user)
  end
end
