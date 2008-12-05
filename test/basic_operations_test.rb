require 'test_helper'

class BasicOperationTests < Test::Unit::TestCase
  def setup
    QueueUnderTest.ensure_running
    @mq = nil

    @test_queues = []
  end

  def teardown
  end

  queue_test(:enqueue_before_dequeue) do
    MQ.new.queue('test').publish('foo')

    MQ.new.queue('test').subscribe do |message|
      assert_equal 'foo', message
      AMQP.stop{ EM.stop_event_loop }
    end
  end

  queue_test(:dequeue_before_enqueue) do
    MQ.new.queue('test').subscribe do |message|
      assert_equal 'foo', message
      AMQP.stop{ EM.stop_event_loop }
    end
    MQ.new.queue('test').publish('foo')
  end

  queue_test(:messaging_processing_fails) do
    MQ.new.queue('test').publish('message')

    when_published_to('test') do
      chan = MQ.new
      chan.queue('test').pop(:ack => true) do |h, message|
        # Closing the channel will cause the unacked message to
        # be redelivered.
        chan.close 

        # Setup a new pop request to regrab the message and
        # successfully process it.
        MQ.new.queue('test').pop(:ack => true) do |header, message|
          header.ack
          AMQP.stop { EM.stop }
        end
      end
    end
  end


  #def test_persistent_messages_survive_queue_restart
  #  EM.run do
  #    begin
  #      AMQP.start

  #      EM.add_timer(0) do 
  #        verbose 'Publishing message...'
  #        mq = MQ.new
  #        mq.queue('test').publish('foo', :persistent => true)
  #        mq.close
  #      end
  #      EM.add_timer(1) do
  #        verbose 'Restarting ...'
  #        QueueUnderTest.restart

  #        EM.next_tick do
  #          AMQP.start

  #          verbose 'Subscribing...'
  #          MQ.new.queue('test').subscribe do |message|
  #            assert_equal 'foo', message
  #            AMQP.stop{ EM.stop_event_loop }
  #          end
  #        end
  #      end
  #    ensure
  #      AMQP.stop
  #    end
  #  end
  #end

  #def test_many_inflight_messages_before_consuming
  #  #@messages = 100_000
  #  @messages = 10
  #  @received = 0
  #  EM.run do
  #    AMQP.logging = true
  #    AMQP.start

  #    @messages.times do |i|
  #      EM.add_timer(0) do
  #        mq = MQ.new
  #        mq.queue('test').publish('foo')
  #        verbose "#{i + 1} messages queued..." if ((i + 1) % 1000 == 0)
  #      end
  #      verbose "#{@messages} messages queued..."

  #      MQ.new.queue('test').subscribe do |message|
  #        @received += 1
  #        verbose "#{@received} messages dequeued..." if (@received % 1000 == 0)
  #        AMQP.stop{ EM.stop_event_loop } if @received >= @messages
  #      end
  #    end
  #  end

  #  verbose "#{@received} messages dequeued..."
  #end
  #
end
