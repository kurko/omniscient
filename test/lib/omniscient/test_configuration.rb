require "test/unit"
require "omniscient"
require "configuration"

class ConfigurationTest < Test::Unit::TestCase
  
  def setup
    @right_path = File.expand_path('~/.omniscient_conf.yml')
    @test_path = File.expand_path("../../../resources/configurations/omniscient_conf.yml", __FILE__)
  end

  def test_right_path
    Omniscient::Configuration.PATH = @right_path
    assert_equal @right_path, Omniscient::Configuration.PATH
  end
  
  def test_change_path
    Omniscient::Configuration.PATH = @test_path
    assert_equal Omniscient::Configuration.PATH, @test_path
    Omniscient::Configuration.PATH = @right_path
    assert_equal Omniscient::Configuration.PATH, @right_path
  end
  
  def test_load_configuration
    original_path = Omniscient::Configuration.PATH
    Omniscient::Configuration.PATH = @test_path
    conf = Omniscient::Configuration::load
    assert conf.kind_of? Hash
    assert conf["foo"]["ssh"]["address"] == "foo@192.168.0.100"
    assert Omniscient::Configuration.configuration.kind_of? Hash
    assert Omniscient::Configuration.configuration["foo"]["ssh"]["address"] == "foo@192.168.0.100"
    conf = Omniscient::Configuration::load "foo"
    assert conf.kind_of? Hash
    assert conf["ssh"]["address"] == "foo@192.168.0.100"
    conf = Omniscient::Configuration::load :foo
    assert conf.kind_of? Hash
    assert conf["ssh"]["address"] == "foo@192.168.0.100"

    # inexistent key
    conf = Omniscient::Configuration::load :lolwut
    assert conf.kind_of? FalseClass
    assert !conf

    Omniscient::Configuration.PATH = original_path
  end
  
end