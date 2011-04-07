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
   
      def access_statements
        str = ''
        str << ' -u '+self.user unless self.user.nil?
        str << ' '+self.database unless self.database.nil?
        str << ' -p'+self.password unless self.password.empty?
        str
      end
      
      def dump
        str = 'mysqldump'
        str << access_statements
        str << ' '+self.table unless self.database.nil? || self.table.nil?
        str << ' --single-transaction'
        str << ' > .omni_dump.sql'
        str
      end
      
      def import
        str = 'mysql'
        str << access_statements
        str << ' < '+Omniscient::DUMP_LOCAL_PATH
        str
      end
    end
  end
end