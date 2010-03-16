$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module AmqpUtils
  
end

require 'rubygems'

gem 'trollop'
require 'trollop'

gem 'amqp'
require 'mq'

gem 'facets'
require 'facets/string/tab'
require 'facets/kernel/returning'
require 'facets/module/basename'

gem 'clio'
require 'clio/consoleutils'

gem 'json'
require 'json'
