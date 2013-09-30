module Opportunist
  class NflFantasyClient
    SIGN_IN_URL = 'https://id2.s.nfl.com/fans/login'

    def initialize(username, password)
      @username = username
      @password = password
      @agent = Mechanize.new
    end

    private

    def sign_in
      page = @agent.get(SIGN_IN_URL)
      form = page.form_with(id: 'sign-in-form')
      form.username = @username
      form.password = @password
      @agent.submit(form)
    end
  end
end
