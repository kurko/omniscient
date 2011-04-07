module Omniscient

  module Command

    class Run
      def initialize argv = ''
        @argv = argv
        
        @configurations = Omniscient::Configuration.new
        
        if Shell::Parser.is_option "help", argv
          help if self.respond_to?('help')
          exit
        end

        if( self.respond_to?('run') )
          run
        elsif( self.respond_to?('help') )
          help
        end
        
      end
      
      def request_configuration
        @configurations.configuration @configurations.questions(:alias_name => @alias_name)
      end
      
    end
  
  end

end