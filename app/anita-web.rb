require "sinatra/base"
require "sinatra/respond_to"
require "date"
require "json"
require "haml"
require "liquid"

require_relative "../lib/anita"

class AnitaWeb < Sinatra::Base
  register Sinatra::RespondTo

  set :default_content, :html

  configure do
    mime_type :markdown, "text/plain"
  end

  get "/" do
    "Oh hai, I'm Anita :]"
  end

  get "/:channel/:from..:to" do |channel, from, to|
    from = DateTime.parse(from).to_s
    to   = DateTime.parse(to).to_s

    messages = Anita::Storage::Statements::Read
      .execute("from" => from, "to" => to)
      .to_a

    respond_to do |f|
      f.html do
        haml(:transcript, locals: {channel: channel, messages: messages})
      end

      f.json do
        messages.to_json
      end

      f.markdown do
        liquid(:transcript, locals: {channel: channel, messages: messages})
      end
    end
  end
end
