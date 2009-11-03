class AmqpUtils::MessageFormatter
  class << self
    @@formatters ||= {}

    def for_type(format_type)
      @@formatters[format_type.downcase].new
    end

    def register_formatter(formatter, format_type)
      @@formatters[format_type.downcase] = formatter
    end
  end

  class Base
    def self.inherited(klass)
      ::AmqpUtils::MessageFormatter.register_formatter(klass, klass.basename)
    end
  end

  class Pretty < Base
    def generate(io, header, message)
      io.puts "  Header: "
      header.properties.each do |key, value|
        io.puts "    #{key.inspect} => #{value.inspect}"
      end
      io.puts "  Message: #{message.inspect}"
    end
  end

  class JSON < Base
    def generate(io, header, message)
      json_obj = {'header' => header.properties, 'message' => message}
      io.puts ::JSON.generate(json_obj)
    end
  end

  class Message < Base
    def generate(io, header, message)
      io.puts message
    end
  end
end
