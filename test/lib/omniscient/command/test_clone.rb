require "test/unit"
require File.expand_path("../../../../set_test_environment.rb", __FILE__)
require "omniscient"
require "command/clone"

class CloneTest < Test::Unit::TestCase
  def setup
    test_path = File.expand_path("../../../../resources/configurations/omniscient_conf.yml", __FILE__)
    Omniscient::Configuration.PATH = test_path
    @obj = Omniscient::Command::Clone.new
    @obj.configurations = Omniscient::Configuration.load :foo
    @obj.alias_name = "foo"
  end
   
  def test_has_conf
    assert @obj.configurations_exist? :foo
  end
  
  def test_load_configurations
    assert @obj.load_configurations.kind_of? Hash
    assert @obj.load_configurations.has_key? "ssh"
    assert @obj.configurations.has_key? "ssh"
  end
  
  def test_set_custom_database
    assert_equal @obj.configurations['mysql']['database'], "foo"
    @obj.set_custom_variables ["-d", "custom_database"]
    assert_equal @obj.configurations['mysql']['database'], "custom_database"
  end

  def test_set_custom_address
    assert_equal @obj.configurations['ssh']['address'], "foo@192.168.0.100"
    @obj.set_custom_variables ["--host", "custom_address"]
    assert_equal "custom_address", @obj.configurations['ssh']['address']
  end
  
  def test_instantiate_adapters
    @obj.instantiate_adapters
    assert @obj.ssh.kind_of? Omniscient::Ssh
    assert @obj.scp.kind_of? Omniscient::Scp
    assert @obj.mysql.kind_of? Omniscient::Adapter::MySQL
  end
end