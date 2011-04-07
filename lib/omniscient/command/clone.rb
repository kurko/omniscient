require 'yaml'

module Omniscient
  
  module Command

    class Clone < Omniscient::Command::Run

      def run
 
        @alias_name = Shell::Parser.get_arguments(@argv).first || ""
        
        unless load_configuration_by_alias(@alias_name)
          request_configuration
        end
        
        
        require 'ssh'
        require 'mysql'
        @ssh = Omniscient::Ssh.new(
          @configurations['ssh']          
        )
        puts @ssh.connect
        
      end
   
      def load_configuration_by_alias alias_name
        return false unless alias_name
        
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
        puts 'Help is missing.'
      end
      
    end
    
  end
  
end