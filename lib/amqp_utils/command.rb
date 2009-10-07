require File.dirname(__FILE__) + '/../amqp_utils'

class AmqpUtils::Command
  class << self
    def run(args = ARGV)
      command = new(args)
      command.process_options
      command.validate
      command.go
    rescue RuntimeError => e
      Trollop::die(e.message)
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

      banner %Q{
      |
      |Standard options:
      }.margin
      opt :host, 'The AMQP host to connect to', :default => 'localhost'
      opt :port, 'The AMQP port to connect to', :default => 5672
      opt :vhost, 'The vhost to connect to', :default => '/'
      opt :user, 'The user name to authenticate with', :default => 'guest'
      opt :password, 'The password to connect with', :default => 'guest'
      opt :timeout, 'The connect timeout in seconds', :default => 5
      opt :verbose, 'Print all AMQP commands sent and received.'
    end
  end

  # Called to validate that the supplied command line options and arguments
  # are valid. If there is a problem with the supplied values, and exception
  # should be raised.
  #
  # Subclasses show override this method and do their validation.
  def validate
  end

  def command_name
    File.basename($0)
  end

  def go
    EM.run do
      %w(host port vhost user timeout).each do |val|
        AMQP.settings[val.to_sym] = options[val.to_sym]
      end
      AMQP.settings[:pass] = options.password
      AMQP.logging = options.verbose

      trap("INT") do
        if @nice_tried
          EM.stop
        else
          AMQP.stop { EM.stop }
          @nice_tried = true
        end
      end

      execute
    end
  end
end
