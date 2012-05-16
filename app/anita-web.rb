require "sinatra/base"
require "date"
require "json"
require "haml"

require_relative "../lib/anita"

class AnitaWeb < Sinatra::Base
  configure do
    mime_type :markdown, "text/plain"
  end

  get "/" do
    "Oh hai, I'm Anita :]"
  end

  get "/:channel/:from..:to.:format" do |channel, from, to, ext|
    messages = messages_for(channel, from, to)
    format   = format_for(ext)

    render_transcript(messages, format)
  end

  get "/:channel/:from..:to", provides: "html" do |channel, from, to|
    messages = messages_for(channel, from, to)
    render_transcript(messages)
  end

  private

  def render_transcript(messages, format = :html)
    case format
    when :html
      haml(:transcript, locals: {messages: messages})
    when :json
      messages.to_json
    when :markdown
      erb(:transcript, locals: {messages: messages})
    else
      raise Sinatra::NotFound
    end
  end

  def format_for(ext)
    case ext
    when "html"
      :html
    when "json", "js"
      :json
    when "markdown", "md"
      :markdown
    else
      :unknown
    end
  end

  def messages_for(channel, from, to)
    from = DateTime.parse(from).to_s
    to   = DateTime.parse(to).to_s

    messages = Anita::Storage::Statements::Read
      .execute("from" => from, "to" => to)
      .to_a

    messages.each do |m|
      ts = DateTime.parse(m["timestamp"])
      m["humanized-timestamp"] = ts.strftime("%Y-%m-%d %H:%M:%S UTC")
    end

    messages.define_singleton_method(:channel) do
      channel
    end

    messages
  end
end
