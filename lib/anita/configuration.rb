module Anita
  Configuration = Object.new

  class << Configuration
    attr_accessor :nick, :password, :server, :channels, :database, :plugins
  end
end
