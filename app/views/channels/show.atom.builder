atom_feed do |feed|
  feed.title @channel.title

  @channel.videos.each do |video|
    feed.entry video, url: "https://www.youtube.com/watch?v=#{video.id}" do |entry|
      entry.title video.title
      entry.content video.description, type: 'html'

      entry.link rel: 'enclosure', type: 'audio/mpeg', title: 'mp3', href: media_url(video.id)
    end
  end
end
