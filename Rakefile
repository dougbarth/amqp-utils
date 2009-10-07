require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "amqp-utils"
    gem.summary = %Q{Command line utilities for interacting with AMQP compliant queues}
    gem.description = %Q{Command line utilies for interacting with AMQP compliant queues.
      The intention is provide simple management tools that can be used to complete ad hoc
      housework on an AMQP queue. In addition, simple scripts can be layered over the tools
      when needed.}
    gem.email = "dougbarth@gmail.com"
    gem.homepage = "http://github.com/dougbarth/amqp-utils"
    gem.authors = ["Doug Barth"]
    gem.rubyforge_project = "amqp-utils"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings

    gem.add_dependency('amqp', '>= 0.6.0')
    gem.add_dependency('trollop', '>= 1.10.2')
    gem.add_dependency('facets', '>= 2.4.4')
  end
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "amqp-utils #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
