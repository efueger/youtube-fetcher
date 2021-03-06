class ChannelsController < ApplicationController
  def show
    @podcast = Podcast.find_or_create_by origin_id: params[:id]
    @channel = Yt::Channel.new id: params[:id]

    @videos = @podcast.episodes.order('published_at DESC').limit(10)

    schedule_episodes_fetching
  end

  private

  def schedule_episodes_fetching
    return if @podcast.updated_at > 10.minutes.ago && @podcast.updated_at > @podcast.created_at
    @channel.videos.where(order: 'date').take(10).reverse.each do |video|
      FetchEpisodeJob.perform_later @podcast, video.id
    end
  end
end
