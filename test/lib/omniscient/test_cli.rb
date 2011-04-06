require "test/unit"
require "omniscient"
require "cli"

class SshTest < Test::Unit::TestCase
  
  def tear_down
    @cli = nil
  end
  
  def setup
    @cli = Omniscient::Cli.new ' clone remotealias'
  end

  def test_initialization
    assert_equal 'localhost', @ssh.hostname
    assert_equal 'user', @ssh.user
  end

end