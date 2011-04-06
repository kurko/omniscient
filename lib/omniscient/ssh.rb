module Omniscient
  class Ssh
    
    def initialize( config )
      @attributes = config
    end
    
    def method_missing( name, *args, &block )
      if args.empty? && block.nil? && @attributes.has_key?(name)
        @attributes[name.to_sym]
      else
        nil
      end
    end
    
    def address
      return false unless self.hostname
      address = ""
      address << self.user+'@' if self.user
      address << self.hostname
    end
    
    def connect( custom_message = '' )
      command = "ssh "+self.address
      command << " '"+custom_message+"'" unless custom_message.empty?
      command
    end
    
  end
end