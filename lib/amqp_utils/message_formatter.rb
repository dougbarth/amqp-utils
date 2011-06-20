class AmqpUtils::MessageFormatter
  class << self
    @@formatters ||= {}

    def for_type(format_type)
      klass = @@formatters[format_type.downcase]
      klass && klass.new
    end

    def types
      @@formatters.keys
    end

    def register_formatter(formatter, format_type)
      @@formatters[format_type.downcase] = formatter
    end
  end

  class Base
    def self.inherited(klass)
      ::AmqpUtils::MessageFormatter.register_formatter(klass, klass.basename)
    end

    def generate(io, header, message)
      raise NotImplementedError, "#{self} does not know how to generate output"
    end

    def load(io)
      raise NotImplementedError, "#{self} does not know how consume its output"
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

    def load(io)
      next_line = io.gets
      ::JSON.parse(next_line) if next_line
    end
  end

  class Message < Base
    def generate(io, header, message)
      io.puts message
    end

    def load(io)
      io.gets
    end
  end
end
