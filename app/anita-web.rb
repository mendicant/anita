require "sinatra/base"
require "date"
require "json"
require "haml"
require "liquid"

require_relative "../lib/anita"

class AnitaWeb < Sinatra::Base
  configure do
    mime_type :markdown, "text/plain"
  end

  get "/" do
    "Oh hai, I'm Anita :]"
  end

  get "/:channel/:from..:to.:format" do |channel, from, to, format|
    messages = messages_for(channel, from, to)

    case format
    when "html"
      haml(:transcript, locals: {channel: channel, messages: messages})
    when "json"
      messages.to_json
    when "markdown"
      liquid(:transcript, locals: {channel: channel, messages: messages})
    else
      raise Sinatra::NotFound
    end
  end

  private

  def messages_for(channel, from, to)
    from = DateTime.parse(from).to_s
    to   = DateTime.parse(to).to_s

    Anita::Storage::Statements::Read
      .execute("from" => from, "to" => to)
      .to_a
  end
end
