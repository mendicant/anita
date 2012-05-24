require "sinatra/base"
require "date"
require "json"
require "haml"
require "cgi"

require_relative "../lib/anita"

class AnitaWeb < Sinatra::Base
  InvalidDateString = BasicObject.new

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
    render_activities(params)
  end

  get "/activities/:description", provides: "html" do
    render_activities(params)
  end

  get "/activity/new" do
    haml(:new_activity, locals: {errors: []})
  end

  post "/activity/new" do
    create_activity(params)
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
    description = CGI.unescape(description)
    activity    = Anita::Activities.load(description)

    raise Sinatra::NotFound if activity.nil?

    Anita::Messages.load_from_activity(activity)
  end

  def create_activity(options)
    description = options["description"]
    channel     = options["channel"]
    started_at  = options["started_at"]
    ended_at    = options["ended_at"]

    success, errors = Anita::Activities.create(
      description, channel, started_at, ended_at
    )

    if success
      description = CGI.escape(description)
      redirect("/activities/#{description}")
    else
      haml(:new_activity, locals: {errors: errors})
    end
  end
end
