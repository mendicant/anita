require "cinch"
require "dm-core"
require "dm-migrations"
require "forwardable"

require_relative "../config/environment"

require_relative "anita/bot"
require_relative "anita/messages"
require_relative "anita/transcripts"

DataMapper.setup(:default, "sqlite://#{Anita::Config::DB}")
DataMapper.finalize
DataMapper.auto_upgrade!
