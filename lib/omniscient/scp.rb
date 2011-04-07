module Omniscient
  class Scp
    
    def initialize( config )
      @attributes = config
    end
    
    def method_missing( name, *args, &block )
      if args.empty? && block.nil? 
        if @attributes.has_key?(name.to_s) 
          @attributes[name.to_s]
        elsif @attributes.has_key?(name.to_sym) 
          @attributes[name.to_sym]
        else
          nil
        end
      else
        nil
      end
    end
    
    def get_address
      return false unless self.address
      self.address
    end
    
    def connect( custom_message = '' )
      command = "scp "+self.get_address.to_s
      command.to_s
    end
    
  end
end