require 'rubygems'

gem 'trollop'
require 'trollop'

gem 'amqp'
require 'mq'

gem 'facets'
require 'facets/string/tab'

class Command
  class << self
    def run(args = ARGV)
      command = new(args)
      command.process_options
      command.go
    end
  end

  def initialize(args)
    @args = args
  end

  attr_reader :args, :options

  def process_options
    command = self
    @options = Trollop::options(@args) do
      command.prepare_options(self) if command.respond_to?(:prepare_options)

      opt :verbose, 'Print all AMQP commands sent and received.'
    end
  end

  def go
    EM.run do
      AMQP.logging = options.verbose

      trap("INT") { AMQP.stop { EM.stop } }

      execute
    end
  end
end
