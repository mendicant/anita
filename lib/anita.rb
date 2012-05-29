require "cinch"
require "dm-core"
require "dm-migrations"
require "forwardable"

require_relative "anita/bot"
require_relative "anita/messages"
require_relative "anita/transcripts"

module Anita
  def self.setup_db
    DataMapper.setup(:default, "sqlite://#{Anita::Config::DB}")
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end

  def self.start_bot
    Bot.start
  end

  def self.start
    setup_db
    start_bot
  end
end
