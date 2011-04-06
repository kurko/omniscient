module Omniscient

  module Command

    class Run
      def initialize argv
        
        if Shell::Parser.is_option "help", argv then
          help
          exit
        end

        if( self.respond_to?('run') )
          run
        elsif( self.respond_to?('help') )
          help
        end
        
      end
      
    end
  
  end

end