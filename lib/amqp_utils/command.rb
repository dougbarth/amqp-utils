require File.dirname(__FILE__) + '/../amqp_utils'

class AmqpUtils::Command
  include Clio::Terminal

  class << self
    def run(args = ARGV)
      command = new(args)
      command.process_options
      command.validate

      begin
        command.go
      rescue => e
        STDERR.puts e.message
        STDERR.puts e.backtrace.join("\n") if command.options.verbose
        exit 1
      end
    end
  end

  def initialize(args)
    @args = args
  end

  def version
    IO.read(File.join(File.dirname(__FILE__), '..', '..', 'VERSION'))
  end

  attr_reader :args, :options

  def process_options
    command = self
    @options = Trollop::options(@args) do
      version(command.version)
      command.prepare_options(self) if command.respond_to?(:prepare_options)

      banner <<-END.unindent
      
      Standard options:
      END
      opt :host, 'The AMQP host to connect to', :short => 'H', :default => 'localhost'
      opt :port, 'The AMQP port to connect to', :short => 'P', :default => 5672
      opt :vhost, 'The vhost to connect to', :short => 'V', :default => '/'
      opt :user, 'The user name to authenticate with', :default => 'guest', :short => 'u'
      opt :prompt, 'Prompt the user for a password', :short => 'p'
      opt :password, 'The password to connect with.', :default => 'guest', :short => :none
      conflicts(:prompt, :password)
      opt :timeout, 'The connect timeout in seconds', :default => 5, :short => 't'
      opt :verbose, 'Print all AMQP commands sent and received.', :short => 'v'
    end

    @args = @args.dup
    ARGV.clear
  end

  # Called to validate that the supplied command line options and arguments
  # are valid. If there is a problem with the supplied values, Trollop::die
  # should be called.
  #
  # Subclasses should override this method and do their validation.
  def validate
  end

  def command_name
    File.basename($0)
  end

  def go
    if options.prompt
      options[:password] = password()
      puts
    end

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

    EM.run do
      amqp.connection_status do |status|
        if status == :disconnected
          Trollop::die "disconnected from #{AMQP.settings[:host]}:#{AMQP.settings[:port]}"
        end
      end

      mq.callback { execute }
    end
  end

  def amqp
    @amqp ||= AMQP.start
  end

  def channel
    @channel ||= AMQP::Channel.new(@amqp)
  end
  alias mq channel
end
