module Opportunist
  class NflFantasyClient
    SIGN_IN_URL = 'https://id2.s.nfl.com/fans/login'
    PLAYERS_BASE_URL = 'http://fantasy.nfl.com/league/%{id}/players?playerStatus=available'
    PLAYERS_URLS = {
      defense: "#{PLAYERS_BASE_URL}&position=8",
      kicker: "#{PLAYERS_BASE_URL}&position=7",
      quarterback: "#{PLAYERS_BASE_URL}&position=1",
      running_back: "#{PLAYERS_BASE_URL}&position=2",
      tight_end: "#{PLAYERS_BASE_URL}&position=4",
      wide_receiver: "#{PLAYERS_BASE_URL}&position=3"
    }

    def initialize(username, password, league_id, position)
      @username = username
      @password = password
      @league_id = league_id
      @position = position
      @agent = Mechanize.new
    end

    def available_players
      @available_players ||= table_rows.map do |row|
        row.at_css('td.playerNameAndInfo a.playerName').content.strip
      end
    end

    private

    def page
      if @page
        @page
      else
        sign_in
        @page = @agent.get(url)
      end
    end

    def sign_in
      page = @agent.get(SIGN_IN_URL)
      form = page.form_with(id: 'sign-in-form')
      form.username = @username
      form.password = @password
      @agent.submit(form)
    end

    def table_rows
      @table_rows ||= page.search('table.tableType-player > tbody > tr').map do |row|
        row.css('td')
      end
    end

    def url
      PLAYERS_URLS[@position] % { id: @league_id }
    end
  end
end
