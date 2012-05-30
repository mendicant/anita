require "timecop"
require "rack/test"
require_relative "../../lib/anita"
require_relative "../../app/anita_web"

ENV["RACK_ENV"] = "test"

RSpec.configure do |c|
  c.include Rack::Test::Methods
end

ts = Time.utc(2012, 1, 1)
Timecop.freeze(ts)

Anita.configure do |c|
  c.nick     = "test-bot"
  c.password = ""
  c.server   = "irc.freenode.net"
  c.channels = ["#cinch-bots"]
  c.database = "sqlite3::memory:"
end

Anita.setup_db
