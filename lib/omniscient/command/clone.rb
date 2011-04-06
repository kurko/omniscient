module Omniscient
  
  module Command

    class Clone < Omniscient::Command::Run

      def run
        puts 'Working.'
      end
      
      def help
        puts 'Help is missing.'
      end
      
    end
    
  end
  
end