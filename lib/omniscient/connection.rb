require 'configuration'
require 'ssh'

module Omniscient
  class Connection
    def initialize
      @configuration = Omniscient::Configuration.new
    end
  end
end
