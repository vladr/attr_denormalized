# AttrDenormalized

module AttrDenormalized # :nodoc:
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_denormalized(attr_name, source, options = {})
	    class_eval <<-EOV, __FILE__, __LINE__
	      def #{attr_name}
	        self.read_attribute(:#{attr_name}) || self.denormalize_#{attr_name}
	      end
	
	      def #{attr_name}=(value)
	        raise "Read-only attribute #{attr_name}"
	      end
	
	      def denormalize_#{attr_name}
	        self.write_attribute(:#{attr_name}, (#{source}))
	      end

		    before_#{options[:on] || 'save'} :denormalize_#{attr_name}
	    EOV
    end # attr_denormalized
  end # ClassMethods
end # AttrDenormalized

ActiveRecord::Base.class_eval do
  include AttrDenormalized
end
