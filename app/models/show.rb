class Show < ActiveRecord::Base
  has_many :trackings
  has_many :users, through: :trackings

  attr_accessible :title, :last_episode, :last_title, :last_airdate, :next_episode, :next_title, :next_airdate, :status, :airtime, :banner

  # Called by #batch_update_next_airdate!
  def update_next_airdate!

  end

  class << self
    def show_available?(query)
      response = HTTParty.get('http://services.tvrage.com/tools/quickinfo.php', :query => {:show => query}, :format => :html)
      response.parsed_response.include?("No Show Results Were Found")
    end

    def create_show_data(query)
      response = HTTParty.get('http://services.tvrage.com/tools/quickinfo.php', :query => {:show => query}, :format => :html) 
      show_data = Crack::XML.parse(response)["pre"]

      raise ShowNotFound unless show_data

      title = "" ; latest_episode = "" ; next_episode = "" ; status = "" ; airtime = ""

      show_data.split("\n").each do |data|
        title          = data if data[/^Show Name/]
        latest_episode = data if data[/^Latest Episode/]
        next_episode   = data if data[/^Next Episode/]
        status         = data if data[/^Status/]
        airtime        = data if data[/^Airtime/]
      end

      title = title.match(/@(.+)$/).captures.first unless title.blank?

      tvdb = TvdbParty::Search.new(ENV["TVDB_API_KEY"])
      show = tvdb.get_series_by_id(tvdb.search(title).first["seriesid"])
      banner = show.series_banners('en').first.url

      Show.create!({ 
        title: title,
        last_episode: latest_episode[/(\d+x\d+)/],
        last_title: latest_episode.match(/\^(.+)\^/).captures.first,
        last_airdate: latest_episode.match(/\^(\D{3}\/\d{2}\/\d{4})$/).captures.first,
        next_episode: next_episode.present? ? next_episode[/(\d+x\d+)/] : nil,
        next_title: next_episode.present? ? next_episode.match(/\^(.+)\^/).captures.first : nil,
        next_airdate: next_episode.present? ? next_episode.match(/\^(\D{3}\/\d{2}\/\d{4})$/).captures.first : nil,
        status: status.match(/@(.+)$/).captures.first,
        airtime: airtime.present? ? airtime.match(/@(.+)$/).captures.first : nil,
        banner: banner
      })
    end

    # To be called by a cron job to systematically update all recurring shows' next airdates
    def batch_update_next_airdate!
      Show.where('next_air_date < ? AND status = ?', Time.now, 'Returning Series').each{ |show| show.update_next_air_date!}
    end
  end
end