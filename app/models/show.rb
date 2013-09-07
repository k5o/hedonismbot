class Show < ActiveRecord::Base
  has_many :trackings
  has_many :users, through: :trackings

  attr_accessible :title, :last_episode, :last_title, :last_airdate, :next_episode, :next_title, :next_airdate, :status, :airtime, :banner

  # Called by #batch_update_next_airdate!
  def update_next_airdate!

  end

  class << self
    def show_available?(query)
      # Returns canonical show title if true
      check_for_show_data(query) ? check_for_show_data.match(/Show Name@(.+)\nShow URL{1}/).captures.first : false
    end

    def create_show_data(canonical_title, show_id)
      show_data = check_for_show_data(canonical_title)
      raise ShowNotFound unless show_data

      latest_episode = "" ; next_episode = "" ; status = "" ; airtime = ""

      show_data.split("\n").each do |data|
        latest_episode = data if data[/^Latest Episode/]
        next_episode   = data if data[/^Next Episode/]
        status         = data if data[/^Status/]
        airtime        = data if data[/^Airtime/]
      end

      Show.create!({
        id:           show_id, 
        title:        canonical_title,
        last_episode: latest_episode[/(\d+x\d+)/],
        last_title:   latest_episode.match(/\^(.+)\^/).captures.first,
        last_airdate: latest_episode.match(/\^(\D{3}\/\d{2}\/\d{4})$/).captures.first,
        next_episode: next_episode.present? ? next_episode[/(\d+x\d+)/] : nil,
        next_title:   next_episode.present? ? next_episode.match(/\^(.+)\^/).captures.first : nil,
        next_airdate: next_episode.present? ? next_episode.match(/\^(\D{3}\/\d{2}\/\d{4})$/).captures.first : nil,
        status:       status.match(/@(.+)$/).captures.first,
        airtime:      airtime.present? ? airtime.match(/@(.+)$/).captures.first : nil,
        banner:       fetch_show_banner(canonical_title)
      })
    end

    # To be called by a cron job to systematically update all recurring shows' next airdates
    def batch_update_next_airdate!
      Show.where('next_air_date < ? AND status = ?', Time.now, 'Returning Series').each{ |show| show.update_next_air_date!}
    end

    def check_for_show_data(query)
      response = HTTParty.get('http://services.tvrage.com/tools/quickinfo.php', :query => {:show => query}, :format => :html)

      Crack::XML.parse(response)["pre"]
    end

    def fetch_show_banner(title)
      tvdb   = TvdbParty::Search.new(ENV["TVDB_API_KEY"])
      show   = tvdb.get_series_by_id(tvdb.search(title).first["seriesid"])

      show.series_banners('en').first.url
    end
  end
end