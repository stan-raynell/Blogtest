class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params.merge(user: current_user))
    redirect_to @article
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    return unless @comment.user == current_user || current_user.admin?

    @comment.destroy
    redirect_to @article, status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body, :status, :user)
  end
end
