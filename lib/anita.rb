require "cinch"
require "dm-core"
require "dm-migrations"
require "forwardable"

require_relative "anita/bot"
require_relative "anita/messages"
require_relative "anita/transcripts"
require_relative "anita/configuration"

module Anita
  def self.configure
    yield(Configuration)
  end

  def self.setup_db
    DataMapper.setup(:default, Configuration.database)
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end

  def self.start_bot
    bot = Bot.new
    bot.start
  end

  def self.start
    setup_db
    start_bot
  end
end

require_relative "../config/environment"
