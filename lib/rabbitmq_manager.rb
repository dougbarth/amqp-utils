require 'rubygems'
gem 'FooBarWidget-daemon_controller'
require 'daemon_controller'

class RabbitMQManager
  class << self
    RABBITMQ_HOME = File.join(File.dirname(__FILE__), "../queues/rabbitmq_server-1.4.0")

    def start
      controller.start
    end

    def stop
      controller.stop
    end

    def restart
      controller.stop
      controller.start
    end

    def ensure_running
      controller.start unless is_running?
    end

    def is_running?
      controller.running?
    end

    private
      def controller
        @@controller ||= DaemonController.new(
          :identifier => 'RabbitMQ',
          :start_command => "#{sbin_dir}/rabbitmq-pidded-server",
          :stop_command => "#{sbin_dir}/rabbitmqctl stop",
          :ping_command => lambda { !`#{sbin_dir}/rabbitmqctl status`.grep(/running/).empty? },
          :pid_file => 'rabbitmq.pid',
          :log_file => '/var/log/rabbitmq/rabbit.log',
          :start_timeout => 60
        )
      end

      def sbin_dir
        File.join(RABBITMQ_HOME, 'sbin')
      end
  end
end
