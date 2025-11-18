class HomeController < ApplicationController
  def ranking
    if user_signed_in?
      @my_rankings = current_user.videos
                        .select('videos.*, COUNT(posts.id) AS view_count')
                        .joins(:posts)
                        .group('videos.id')
                        .order('view_count DESC')
    end

    @all_rankings = Video
                     .select('videos.*, COUNT(posts.id) AS total_views')
                     .joins(:posts)
                     .group('videos.id')
                     .order('total_views DESC')
  end
end
