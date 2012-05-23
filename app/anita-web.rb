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

  get "/:channel/:from..:to.:format" do
    render_transcript(params)
  end

  get "/:channel/:from..:to", provides: "html" do
    render_transcript(params)
  end

  get "/activities/:description.:format" do
  end

  get "/activities/:description", provides: "html" do
    render_activities(params)
  end

  private

  def render_transcript(options)
    channel = options[:channel]
    from    = options[:from]
    to      = options[:to]

    messages = messages_for(channel, from, to)
    render_messages(messages, options)
  end

  def render_activities(options)
    description = options[:description]

    messages = messages_for_activity(description)
    render_messages(messages, options)
  end

  def render_messages(messages, options)
    format = format_for(options[:format] || "html")

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
    channel = "##{channel}"
    from = DateTime.parse(from).to_s
    to   = DateTime.parse(to).to_s

    Anita::Messages.load(channel, from, to)
  end

  def messages_for_activity(description)
    activity = Anita::Activities.load(description)
    Anita::Messages.load_from_activity(activity)
  end
end
