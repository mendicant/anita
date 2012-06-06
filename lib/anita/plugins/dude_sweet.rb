module Anita
  module Plugins
    class DudeSweet
      include Cinch::Plugin

      match /\bdude\b/,  method: :say_sweet, use_prefix: false
      match /\bsweet\b/, method: :say_dude,  use_prefix: false

      def say_sweet(message)
        message.reply("sweet")
      end

      def say_dude(message)
        message.reply("dude")
      end
    end
  end
end
