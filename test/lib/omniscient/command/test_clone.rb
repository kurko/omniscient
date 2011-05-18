require "test/unit"
require File.expand_path("../../../../set_test_environment.rb", __FILE__)
require "omniscient"
require "command/clone"

class CloneTest < Test::Unit::TestCase
  def setup
    test_path = File.expand_path("../../../../resources/configurations/omniscient_conf.yml", __FILE__)
    Omniscient::Configuration.PATH = test_path
  end
   
  def test_has_conf
    @obj = Omniscient::Command::Clone.new
    assert @obj.configurations_exist? :foo
  end
end