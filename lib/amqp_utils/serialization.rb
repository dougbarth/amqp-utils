class AmqpUtils::Serialization
  def self.deserialize(content_type, message)
    if serializer = serializers[content_type]
      serializer.deserialize(message) 
    else
      message
    end
  end

  def self.serialize(content_type, message)
    if serializer = serializers[content_type]
      serializer.serialize(message) 
    else
      message
    end
  end

  def self.serializers
    @@serializers ||= {}
  end

  class Base
    def self.content_type(*content_types)
      content_types.each do |ctype|
        AmqpUtils::Serialization.serializers[ctype] = self
      end
    end
  end

  class MsgPack < Base
    content_type 'application/msgpack'

    def self.deserialize(message)
      require 'msgpack'
      MessagePack.unpack(message)
    end

    def self.serialize(message)
      require 'msgpack'
      message.to_msgpack
    end
  end

  class Json < Base
    content_type 'text/json', 'application/json'

    def self.deserialize(message)
      ::JSON.parse(message)
    end

    def self.serialize(message)
      ::JSON.generate(message)
    end
  end
end
