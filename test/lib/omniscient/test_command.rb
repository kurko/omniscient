require "test/unit"
require "omniscient"

class SshTest < Test::Unit::TestCase
  
  def tear_down
    @command = nil
  end
  
  def setup
    @command = Omniscient::Command::Run.new
  end

  def test_initialization

  end

end