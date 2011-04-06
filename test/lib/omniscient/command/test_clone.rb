require "test/unit"
require "omniscient/command/clone"

class CloneTest < Test::Unit::TestCase
  def test_start
    assert_equal 'start', Omniscient::Command::Clone.start()
  end
end