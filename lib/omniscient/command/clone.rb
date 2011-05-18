require 'yaml'
require 'ssh'
require 'scp'
require 'adapters/mysql'

module Omniscient
  module Command
    class Clone < Omniscient::Command::Run

      def run
        @alias_name = Shell::Parser.get_arguments(@argv).first || ""
        
        (help; exit) if @alias_name.empty?
        
        request_configuration unless has_conf @alias_name

        database = Shell::Parser.get_option_value('d', @argv) || nil
        @configurations['mysql']['database'] = database unless database.empty?
        
        @ssh = Omniscient::Ssh.new(@configurations['ssh'])
        @scp = Omniscient::Scp.new(@configurations['ssh'])
        @mysql = Omniscient::Adapter::MySQL.new(@configurations['mysql'])

        # Dumps remotely
        command_to_issue = "#{@ssh.connect} '#{@mysql.dump}'"
        puts "Running => #{command_to_issue}"
        exit unless system command_to_issue

        # Copies dumped data
        command_to_issue = "#{@scp.connect}:"+Omniscient::DUMP_REMOTE_PATH+" "+Omniscient::DUMP_LOCAL_PATH
        puts "Running => #{command_to_issue}"
        exit unless system command_to_issue
        
        # Imports data
        command_to_issue = "#{@mysql.import}"
        puts "Running => #{command_to_issue}"
        exit unless system command_to_issue
      end
      
      def configurations_exist? alias_name
        Omniscient::Configuration::load alias_name
      end
      
      def load_configuration_by_alias alias_name
        return false unless alias_name
        return false unless File.exist?(File.expand_path('~/.omniscient_conf.yml'))
        
        config_file = File.new(File.expand_path('~/.omniscient_conf.yml'), 'r')
        existing_configurations = YAML::load(config_file.read)
        if existing_configurations.kind_of?(Hash) && existing_configurations.has_key?(alias_name)
          @configurations = existing_configurations[alias_name]
          true
        else
          false
        end
      end
        
      def help
        print "Usage:\n"
        print "\s\somniscient push ALIAS_NAME [options]"
        print "\n\n"
        print "Options:"
        print "\n"
        print "\s\s-d\tSelect a different database"
        print "\n"
      end
      
    end
    
  end
  
end