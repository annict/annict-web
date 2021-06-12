# frozen_string_literal: true

module Forum
  class HomeController < Forum::ApplicationController
    def show
      @posts = ForumPost.all.joins(:user).merge(User.only_kept)
      @posts = localable_resources(@posts).order(last_commented_at: :desc).page(params[:page]).without_count
    end
  end
end