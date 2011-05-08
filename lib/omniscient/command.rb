require "version"

module Omniscient

  module Command

    class Run
      def initialize argv = ''
        @argv = argv
        
        @configurations = Omniscient::Configuration.new
        
        unless (["h", "help"] & Shell::Parser.get_options(argv)).empty?
          help if self.respond_to?('help')
          exit
        end
        unless (["v", "version"] & Shell::Parser.get_options(argv)).empty?
          version if self.respond_to?('version')
          exit
        end

        if( self.respond_to?('run') )
          run
        elsif( self.respond_to?('help') )
          print "Inexistent command.\n"
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
        print "Version: "
        print Omniscient::VERSION
        print "\n"
      end
      
    end
  
  end

end