require "test/unit"
require "omniscient"
require "connection"

class ConnectionTest < Test::Unit::TestCase
  def setup
    @conn = Omniscient::Connection.new
  end
end