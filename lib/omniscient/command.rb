require "version"
require "configuration"

module Omniscient

  module Command
    
    class Run

      attr_accessor :argv, :configurations

      def initialize argv = ''
        @argv = argv
        
        @configurations = Omniscient::Configuration.load
        
        unless (["h", "help"] & Shell::Parser.get_options(argv)).empty?
          help if self.respond_to?('help')
          exit
        end
        unless (["v", "version"] & Shell::Parser.get_options(argv)).empty?
          version if self.respond_to?('version')
          exit
        end

        if self.respond_to?('run')
          run unless defined? TESTING
        elsif self.respond_to?('help')
          help
        end
      end
      
      def request_configuration
        @configurations.configuration @configurations.questions(:alias_name => @alias_name)
      end
      
      def help
        print "Usage:\n"
        print "\s\somniscient COMMAND [options]"
        print "\n\n"
        print "Commands available:"
        print "\n"
        print "\s\sclone\t\tClones a database from a remote server"
        print "\n\n"
        print "Examples:"
        print "\n"
        print "\s\somniscient clone alias_server_name"
        print "\n"
        print "\tClones a database from a remote server. If \n"
        print "\talias_server_name is unknown to Ominiscient, \n"
        print "\tit'll ask you all connection information."
        print "\n\n"
        print "For more information, try:\n"
        print "\s\somniscient COMMAND -h"
        print "\n"
      end
      
      def version
        print "Omniscient v" + Omniscient::VERSION
        print "\n"
      end
      
    end
  
  end

end