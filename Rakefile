require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test' << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task :default => :test

namespace 'queue' do
  $: << 'lib'
  require 'rabbitmq_manager'

  desc 'Stop the queue under test'
  task 'stop' do
    RabbitMQManager.stop
  end

  desc 'Start the queue under test'
  task 'start' do
    RabbitMQManager.start
  end

  desc 'Restarts the queue under test'
  task 'restart' do
    RabbitMQManager.restart
  end

  desc 'Determines the status of the queue'
  task 'status' do
    status = RabbitMQManager.is_running? ? 'RUNNING' : 'STOPPED'
    puts "RabbitMQ is #{status}"
  end
end
