require "dm-core"
require "dm-migrations"
require "timecop"

ts = Time.utc(2012, 1, 1)
Timecop.freeze(ts)

module Anita
  module Config
    NICK     = "test-bot"
    PASSWORD = ""
    SERVER   = "irc.freenode.net"
    CHANNELS = ["#cinch-bots"]
    DB       = "sqlite3::memory:"
  end
end

require_relative "../lib/anita"

Anita.setup_db
