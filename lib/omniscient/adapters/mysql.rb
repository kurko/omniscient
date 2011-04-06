module Omniscient
  module Adapter
    class MySQL
      attr_accessor :attributes
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
   
      def dump
        dump = 'mysqldump'
        dump << ' -u '+self.user unless self.user.nil?
        dump << ' -p'+self.password unless self.password.nil?
        dump << ' '+self.database unless self.database.nil?
        dump << ' '+self.table unless self.database.nil? || self.table.nil?
        dump << ' --single-transaction'
        dump << ' > .omni_dump.sql'
        dump
      end
    end
  end
end