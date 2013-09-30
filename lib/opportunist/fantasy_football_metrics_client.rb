module Opportunist
  class FantasyFootballMetricsClient
    BASE_URL = 'http://www.fantasyfootballmetrics.com'
    PROJECTIONS_URLS = {
      defense: "#{BASE_URL}/Weekly_Rankings_Projections/Sit-Start-D-CurrrentWeek.htm",
      kicker: "#{BASE_URL}/Weekly_Rankings_Projections/Sit-Start-K-CurrentWeek.htm",
      quarterback: "#{BASE_URL}/Weekly_Rankings_Projections/Sit-Start-QB-CurrentWeek.htm",
      running_back: "#{BASE_URL}/Weekly_Rankings_Projections/Sit-Start-RB-CurrentWeek.htm",
      tight_end: "#{BASE_URL}/Weekly_Rankings_Projections/Sit-Start-TE-CurrentWeek.htm",
      wide_receiver: "#{BASE_URL}/Weekly_Rankings_Projections/Sit-Start-WR-CurrentWeek.htm"
    }

    def initialize(position)
      @agent = Mechanize.new
      @position = position
    end

    def players
      @players ||= table_rows.map do |row|
        name = row[3].content.match(/([^,]+),\s*(\S+)/) do |match|
          { first: match[2], last: match[1], full: "#{match[2]} #{match[1]}" }
        end

        { name: name }
      end
    end

    private

    def page
      @page ||= @agent.get(url)
    end

    def table_rows
      @table_rows ||= page.search('table.tableizer-table tr')[1..-1].map do |row|
        row.css('td')
      end
    end

    def url
      PROJECTIONS_URLS[@position]
    end
  end
end
