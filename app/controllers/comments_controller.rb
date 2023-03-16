# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params.merge(user: current_user))
    if @comment.save
      redirect_to @article
    else
      flash.alert = "Empty comment!"
      redirect_to article_path(@article), status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    return unless (@comment.user == current_user) || current_user.admin?

    @comment.destroy
    redirect_to @article, status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body, :status, :user)
  end
end
