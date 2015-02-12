require 'hashie'
module Wakatime
  module Models
    class Item < Hashie::Mash; end
    class Summary < Item; end
    class Heartbeat < Item; end
    class User < Item; end
    class Plugin < Item; end
  end
end
