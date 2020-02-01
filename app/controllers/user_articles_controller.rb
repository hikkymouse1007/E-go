class UserArticlesController < ApplicationController
  before_action :logged_in_user
  def show
    if current_user.user_articles.find_by(id: params[:id])
      @article = UserArticle.find(params[:id])
      all_words = @article.title.scan(/\w+/).uniq(&:downcase) + @article.content.scan(/\w+/).uniq(&:downcase)
      @words = all_words.uniq
      @vocabs = @article.vocabs
    else
      redirect_to root_url
    end
  end

  def new
    @article = UserArticle.new
    @title = params[:title]
    @published_at = params[:publishedAt]
    @url = params[:url]
    @content = params[:content]
  end

  def create
    @article = UserArticle.new(user_article_params)
    @article.user_id = current_user.id
    project_id = ENV["CLOUD_PROJECT_ID"]
    translate = Google::Cloud::Translate.new version: :v2, project_id: project_id
    target = "ja"
    @article.japanese_title = translate.translate @article.title, to: target
    @article.japanese_content = translate.translate @article.content, to: target
    if @article.save
      flash[:success] = "Article created!"
      redirect_to user_article_path(@article)
    else
      redirect_to "/user_articles/new?publishedAt=#{@article.published_at}&title=#{@article.title}}&content=#{@article.content}&url=#{@article.url}", notice: '記入漏れがあります'
    end
  end

  def edit
    @article = UserArticle.find(params[:id])
  end

  def update
    @article = UserArticle.find(params[:id])
    project_id = ENV["CLOUD_PROJECT_ID"]
    translate = Google::Cloud::Translate.new version: :v2, project_id: project_id
    target = "ja"
    @article.japanese_title = translate.translate @article.title, to: target
    @article.japanese_content = translate.translate @article.content, to: target
    if @article.update(user_article_params)
      redirect_to user_article_path(@article), notice: 'Article updated!'
    else
      flash.now[:danger] = '記入漏れがあります'
      render :edit
    end
  end

  def destroy
    article = UserArticle.find(params[:id])
    article.destroy
    flash[:success] = "Article deleted."
    redirect_to user_path(current_user)
  end

  private

  def user_article_params
    params.require(:user_article).permit(:category, :title, :content, :url, :published_at, :japanese_title, :japanese_content)
  end
end
