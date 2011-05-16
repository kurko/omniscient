require "test/unit"
require "omniscient"
require "configuration"

class ConfigurationTest < Test::Unit::TestCase
  
  def setup
  end

  def test_instance_without_configuration
    @obj = Omniscient::Configuration.new :load => false
    assert @obj.configuration.class == TrueClass, @obj.configuration.class.to_s
  end
  
  def test_load_configuration
    @obj = Omniscient::Configuration.new :load => false
    @obj.PATH = File.expand_path("../../../resources/configurations/omniscient_conf.yml", __FILE__)
    conf = @obj.load_configuration
    assert conf =~ /address: foo@192\.168\.0\.100/
  end

end