require "test/unit"
require "omniscient"
require "ssh"

class SshTest < Test::Unit::TestCase
  
  def tear_down
    @ssh = nil
  end
  
  def setup
    @ssh = Omniscient::Ssh.new :hostname => 'localhost', :user => 'user'
  end

  def test_initialization
    assert_equal 'localhost', @ssh.hostname
    assert_equal 'user', @ssh.user
  end
   
  def test_address
    assert_equal 'user@localhost', @ssh.address()
  end

  def test_address_without_user
    @ssh = Omniscient::Ssh.new :hostname => 'localhost'
    assert_equal 'localhost', @ssh.address()
  end

  def test_address_with_port
    @ssh = Omniscient::Ssh.new :hostname => 'localhost', :user => 'user', :port => '22'
    # TODO
  end

  def test_address_with_port
    assert_equal %q{ssh user@localhost 'custom message'}, @ssh.connect('custom message')
  end

end