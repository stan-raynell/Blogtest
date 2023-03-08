class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :index]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
    @article.user = current_user
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.user_id == current_user.id
      if @article.update(article_params)
        redirect_to @article
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash[:danger] = "This is not your article!"
      redirect_to @article
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.user == current_user or current_user.admin?
      @article.destroy
      redirect_to root_path, status: :see_other
    else
      flash[:danger] = "This is not your article!"
      redirect_to @article
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :status, :user_id)
  end
end
