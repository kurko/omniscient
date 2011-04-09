require "test/unit"
require "omniscient/adapters/mysql"

class MySQLTest < Test::Unit::TestCase
  
  def tear_down
    @mysql = nil
  end
  
  def setup
    @mysql = Omniscient::Adapter::MySQL.new(
      :database => 'omniscient',
      :user     => 'root',
      :password => 'pw' )
  end

  def test_initialization
    assert_equal 'omniscient', @mysql.database
    assert_equal 'root', @mysql.user
    assert_equal 'pw', @mysql.password
  end

  def test_valid_configuration?
    @mysql = Omniscient::Adapter::MySQL.new( :database => 'omniscient', :user => 'root', :password => 'pw' )
    assert @mysql.valid_configuration?
    @mysql = Omniscient::Adapter::MySQL.new( :database => 'omniscient', :user => 'root' )
    assert @mysql.valid_configuration?
    @mysql = Omniscient::Adapter::MySQL.new( :user => 'root', :password => 'pw' )
    assert !@mysql.valid_configuration?
  end
  
  def test_dump
    assert_equal %Q{mysqldump -u root -ppw omniscient --single-transaction > .omni_dump.sql}, @mysql.dump()
  end

  def test_dump_if_not_valid_configuration
    @mysql = Omniscient::Adapter::MySQL.new( :user => 'root', :password => 'pw' )
    assert !@mysql.dump
  end

  def test_dump_a_specific_table
    @mysql.attributes[:table] = 'mytable'
    assert_equal %Q{mysqldump -u root -ppw omniscient mytable --single-transaction > .omni_dump.sql}, @mysql.dump()
  end

  def test_importation
    assert_equal %Q{mysql -u root -ppw omniscient < }+Omniscient::DUMP_LOCAL_PATH, @mysql.import()
  end

  def test_importation_if_not_valid_configuration
    @mysql = Omniscient::Adapter::MySQL.new( :user => 'root', :password => 'pw' )
    assert !@mysql.import()
    @mysql = Omniscient::Adapter::MySQL.new( :database => 'anydb' )
    assert !@mysql.import()
  end


end