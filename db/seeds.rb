def seeder(query, canonical_title)
  show_data = check_for_show_data(canonical_title)
  
  latest_episode = "" ; next_episode = "" ; status = "" ; airtime = ""

  show_data.split("\n").each do |data|
    latest_episode = data if data[/^Latest Episode/]
    next_episode   = data if data[/^Next Episode/]
    status         = data if data[/^Status/]
    airtime        = data if data[/^Airtime/]
  end

  Show.create!({
    title:        canonical_title,
    last_episode: latest_episode.present? ? latest_episode[/(\d+x\d+)/] : nil,
    last_title:   latest_episode.present? ? latest_episode.match(/\^(.+)\^/).captures.first : nil,
    last_airdate: latest_episode.present? ? latest_episode.match(/\^(\D{3}\/\d{2}\/\d{4})$/).captures.first : nil,
    next_episode: next_episode.present? ? next_episode[/(\d+x\d+)/] : nil,
    next_title:   next_episode.present? ? next_episode.match(/\^(.+)\^/).captures.first : nil,
    next_airdate: next_episode.present? ? next_episode.match(/\^(\D{3}\/\d{2}\/\d{4})$/).captures.first : nil,
    status:       status.match(/@(.+)$/).captures.first,
    airtime:      airtime.present? ? airtime.match(/@(.+)$/).captures.first : nil,
    banner:       fetch_show_banner(query, canonical_title)
  })
end

def check_for_show_data(query)
  response = HTTParty.get('http://services.tvrage.com/tools/quickinfo.php', :query => {:show => query}, :format => :html)

  Crack::XML.parse(response)["pre"]
end

def fetch_show_banner(query, canonical_title)
  tvdb   = TvdbParty::Search.new(Figaro.env.tvdb_api_key)

  begin
    show   = tvdb.get_series_by_id(tvdb.search(canonical_title).first["seriesid"])
  rescue NoMethodError
    show   = tvdb.get_series_by_id(tvdb.search(query).first["seriesid"])
  rescue NoMethodError
    banner = "#{Rails.root.join('app', 'assets', 'images', '404banner.jpg')}"
  end
    show ? show.series_banners('en').first.url : banner
end

seeder("Game of Thrones", "Game of Thrones")
sleep 2
seeder("Futurama", "Futurama")
sleep 2
seeder("Adventure Time", "Adventure Time")
sleep 2
seeder("Parks and Recreation", "Parks and Recreation")
sleep 2
seeder("Cosmos: A Space-Time Odyssey", "Cosmos: A Space-Time Odyssey")
sleep 2
seeder("Top Gear", "Top Gear")
