module Anita
  Bot = Cinch::Bot.new do
    configure do |c|
      c.nick     = Anita::Config::NICK
      c.password = Anita::Config::PASSWORD
      c.server   = Anita::Config::SERVER
      c.channels = Anita::Config::CHANNELS
    end

    on :channel do |message|
      Messages.save(message)
    end
  end
end
