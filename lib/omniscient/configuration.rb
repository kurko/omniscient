require 'yaml'

module Omniscient
  class Configuration
    
    @PATH = File.expand_path('~/.omniscient_conf.yml')
    
    attr_accessor :PATH, :configuration
    
    def initialize(*args)
      @configuration = true
    end
    
    def method_missing( name, *args, &block )
      if args.empty? && block.nil? && @attributes.has_key?(name)
        @attributes[name.to_sym]
      else
        nil
      end
    end
    
    def load_configuration
      return false unless File.exist? @PATH
      
      config_file = File.new @PATH, 'r'
      existing_configurations = YAML::load config_file.read
      if existing_configurations.kind_of?(Hash) && existing_configurations.has_key?(alias_name)
        @configurations = existing_configurations[alias_name]
        true
      else
        false
      end
    end
    
    def questions informations
      
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
        system "stty -echo"
        print "Database's password [leave it blank if none is needed]: "
        mysql_password = Shell::Input.text
        system "stty echo"
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
