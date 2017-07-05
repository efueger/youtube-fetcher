class ChannelsController < ApplicationController
  def show
    @podcast = Podcast.find_or_create_by origin_id: params[:id]
    @channel = Yt::Channel.new id: params[:id]
    @videos = @channel.videos.where(order: 'date').take(10)

    @videos.each do |video|
      FetchEpisodeJob.perform_later @podcast, video.id
    end
  end
end
