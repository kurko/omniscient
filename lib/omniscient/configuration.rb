require 'yaml'

module Omniscient
  class Configuration
    
    @PATH = File.expand_path('~/.omniscient_conf.yml')
    @configuration = {}
    
    class << self
      attr_accessor :PATH, :configuration
    end
    
    def self.load alias_name = false
      return false unless File.exist? @PATH
      
      config_file = File.new @PATH, 'r'
      existing_configurations = YAML::load config_file.read
      if existing_configurations.kind_of? Hash
        @configuration = existing_configurations
        if alias_name
          return @configuration[alias_name.to_s] unless @configuration[alias_name.to_s].nil?
          return false
        end
        @configuration
      else
        false
      end
    end
    
    def self.questions informations
      
      custom_alias = informations[:alias_name].nil? ? nil : informations[:alias_name]

      unless custom_alias.nil?
        puts "No configuration found for #{custom_alias}. You need to setup a remote machine.\n"
        @configuration = { custom_alias => {} }
      else
        puts "No configuration found. You need to setup a remote machine.\n"
        print "Type an name for this remote machine [a word you want]: "
        custom_alias = Shell::Input.text.downcase
      end

      @configuration = { custom_alias => {} }
      @configuration[custom_alias]['ssh'] = {}
      @configuration[custom_alias]['mysql'] = {}
      
      unless @configuration[custom_alias]['ssh'].has_key?('address')
        print "SSH address [i.e. username@some_ip]: "
        @configuration[custom_alias]['ssh']['address'] = Shell::Input.text
      end

      unless @configuration[custom_alias]['ssh'].has_key?('port')
        print "SSH port [leave empty for default]: "
        ssh_port = Shell::Input.text
        @configuration[custom_alias]['ssh']['port'] = ssh_port.empty? ? 22 : ssh_port.empty?
      end

      unless @configuration[custom_alias]['mysql'].has_key?('user')
        print "Database's username [default's 'root']: "
        mysql_user = Shell::Input.text
        @configuration[custom_alias]['mysql']['user'] = mysql_user.empty? ? 'root' : mysql_user
      end

      unless @configuration[custom_alias]['mysql'].has_key?('password')
        begin
          system "stty -echo"
          print "Database's password [leave it blank if none is needed]: "
          mysql_password = Shell::Input.text
          system "stty echo"
        rescue NoMethodError, Interrupt
            system "stty echo"
            exit
        end
        print "\n"
        @configuration[custom_alias]['mysql']['password'] = mysql_password.empty? ? '' : mysql_password
      end

      unless @configuration[custom_alias]['mysql'].has_key?('database')
        print "The default database name you will work with: "
        mysql_db = Shell::Input.text
        @configuration[custom_alias]['mysql']['database'] = mysql_db.empty? ? '' : mysql_db
      end
      
      config_file = File.new(File.expand_path('~/.omniscient_conf.yml'), 'a+')
      existing_configurations = YAML::load(config_file.read)
      
      if existing_configurations && existing_configurations.kind_of?(Hash)
        @configuration = existing_configurations.merge(@configuration)
      end
      config_file.truncate(0)
      config_file.puts YAML::dump(@configuration)
      config_file.close
      
      puts "\nDone."
      puts "Now, just type: omniscient clone #{custom_alias}"
      exit
      
    end
    
  end
end
