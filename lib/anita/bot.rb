module Anita
  Bot = Cinch::Bot.new do
    configure do |c|
      c.nick     = Anita::Config::NICK
      c.password = Anita::Config::PASSWORD
      c.server   = Anita::Config::SERVER
      c.channels = Anita::Config::CHANNELS
    end

    on(:channel) do |m|
      Messages.save(m)
    end

    on(:message, /^help$/) do |m|
      m.reply("#{m.user.nick}: actions -> activity")
    end

    on(:message, /^activity help$/) do |m|
      m.reply("#{m.user.nick}: usage: activity create +options")
    end

    on(:message, /^activity help create$/) do |m|
      m.reply(
        "#{m.user.nick}: usage: activity create " +
        "(description) (channel) (started_at) (ended_at)"
      )
    end

    on(:message, /^activity create (.*) (.*) (.*) (.*)$/) do
      |m, description, channel, started_at, ended_at|

      success, errors = Anita::Activities.create(
        description, channel, started_at, ended_at
      )

      if success
        m.reply("#{m.user.nick}: activity created.")
      else
        m.reply(
          "#{m.user.nick}: failed to create activity. #{@errors.join(" ")}"
        )
      end
    end
  end
end
