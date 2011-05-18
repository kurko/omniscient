require 'yaml'
require 'ssh'
require 'scp'
require 'adapters/mysql'

module Omniscient
  module Command
    class Clone < Omniscient::Command::Run
      
      attr_accessor :ssh, :scp, :mysql, :alias_name
      
      def run
        @alias_name = Shell::Parser.get_arguments(@argv).first || ""
        
        (help; exit) if @alias_name.empty?
        
        request_configuration unless configurations_exist? @alias_name
        load_configurations
        set_custom_variables
        instantiate_adapters

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
      
      def set_custom_variables argv = false
        database = Shell::Parser.get_option_value('d', (argv || @argv)) || nil
        @configurations['mysql']['database'] = database unless database.empty?

        address = Shell::Parser.get_option_value('host', (argv || @argv)) || nil
        @configurations['ssh']['address'] = address unless address.empty?
      end
      
      def instantiate_adapters
        @ssh = Omniscient::Ssh.new @configurations['ssh']
        @scp = Omniscient::Scp.new @configurations['ssh']
        @mysql = Omniscient::Adapter::MySQL.new @configurations['mysql']
      end
      
      def load_configurations alias_name = false
        @configurations = Omniscient::Configuration.load(alias_name || @alias_name)
      end
        
      def help
        print "Usage:\n"
        print "\s\somniscient clone ALIAS_NAME [options]"
        print "\n\n"
        print "Options:"
        print "\n"
        print "\s\s-d\t\tSelect a different database\n"
        print "\s\s--host\tSelect a different SSH address, e.g. foo@192.168.0.1\n"
      end
      
    end
    
  end
  
end