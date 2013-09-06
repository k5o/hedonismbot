class Show < ActiveRecord::Base
  has_many :trackings
  has_many :users, through: :trackings

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

      show_data.split("\n").each do |data|
        @latest_episode = data if data[/^Latest Episode/]
        @next_episode = data if data[/^Next Episode/]
        @status = data if data[/^Status/]
        @airtime = data if data[/^Airtime/]
      end

      tvdb = TvdbParty::Search.new(ENV['api_key'])
      show = tvdb.get_series_by_id(tvdb.search(query)["seriesid"])
      @banner = show.series_banners('en').first.url

      Show.create!({ 
        last_episode: @latest_episode[/(\d+x\d+)/],
        last_title: @latest_episode.match(/\^(.+)\^/).captures.first,
        last_airdate: @latest_episode.match(/\^(\D{3}\/\d{2}\/\d{4})$/).captures.first,
        next_episode: @next_episode[/(\d+x\d+)/],
        next_title: @next_episode.match(/\^(.+)\^/).captures.first,
        next_airdate: @next_episode.match(/\^(\D{3}\/\d{2}\/\d{4})$/).captures.first,
        status: @status,
        airtime: @airtime.match(/at\W(.+)$/).captures.first,
        banner: @banner
      })
    end

    # To be called by a cron job to systematically update all recurring shows' next airdates
    def batch_update_next_airdate!
      Show.where('next_air_date < ? AND status = ?', Time.now, 'Returning Series').each{ |show| show.update_next_air_date!}
    end
  end
end