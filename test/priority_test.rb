require 'test_helper'

class PriorityTest < Test::Unit::TestCase
  def setup
    QueueUnderTest.ensure_running
  end

  queue_test(:priority_queue_servicing, :timeout => 20) do
    @slow_messages_to_pub = 100

    mq = MQ.new
    mq.queue('fast').publish('fast')
    
    mq = MQ.new
    @mq = mq
    slow_publisher = EM.spawn do |num_messages|
      if num_messages > 0
        @mq ||= MQ.new
        @mq.queue('slow').publish('slow')
        slow_publisher.notify(num_messages - 1)
      end
    end
    slow_publisher.notify(@slow_messages_to_pub)

    publish_spin_lock = EM::PeriodicTimer.new(0.1) do
      @mq.queue('slow').status do |messages, |
        @slow_messages_pubbed = messages
      end
      @mq.queue('fast').status {|messages,| @fast_published = true}
      if @slow_messages_pubbed == @slow_messages_to_pub && @fast_published
        @delay = 0
        @fast_chan = MQ.new
        @fast_chan.queue('fast')
        @slow_chan = MQ.new
        @slow_chan.queue('slow')
        EM.add_timer(1) { subscribe }
        publish_spin_lock.cancel
      end
    end

    def subscribe
      @slow_chan.queue('slow').subscribe do |m|
        @delay += 1
      end

      @fast_chan.queue('fast').subscribe do |m|
        assert @delay < 10
        EM.next_tick { AMQP.stop { EM.stop_event_loop } }
      end
    end
  end
end
