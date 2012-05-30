module Anita
  class Bot
    def initialize
      self.bot = Cinch::Bot.new do
        configure do |c|
          c.nick     = Configuration.nick
          c.password = Configuration.password
          c.server   = Configuration.server
          c.channels = Configuration.channels
        end

        on(:channel) do |message|
          channel = message.channel
          nick    = message.user.nick
          text    = message.message

          Transcripts.record(channel, nick, text)
        end
      end
    end

    def start
      bot.start
    end

    private

    attr_accessor :bot
  end
end
