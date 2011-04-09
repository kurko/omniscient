module Omniscient
  module Adapter
    class MySQL
      attr_accessor :attributes
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
    
      def valid_configuration?
        return false unless database && user
        true
      end
      
      def access_statements
        str = ''
        str << ' -u '+self.user unless self.user.nil?
        str << ' -p'+self.password unless self.password.empty?
        str << ' '+self.database unless self.database.nil?
        str
      end
      
      def dump
        return false unless valid_configuration?
        str = 'mysqldump'
        str << access_statements
        str << ' '+self.table unless self.database.nil? || self.table.nil?
        str << ' --single-transaction'
        str << ' > .omni_dump.sql'
        str
      end
      
      def import
        return false unless valid_configuration?
        str = 'mysql'
        str << access_statements
        str << ' < '+Omniscient::DUMP_LOCAL_PATH
        str
      end
    end
  end
end