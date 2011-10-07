# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{amqp-utils}
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Doug Barth"]
  s.date = %q{2011-10-07}
  s.description = %q{Command line utilies for interacting with AMQP compliant queues.
      The intention is provide simple management tools that can be used to complete ad hoc
      housework on an AMQP queue. In addition, simple scripts can be layered over the tools
      when needed.}
  s.email = %q{dougbarth@gmail.com}
  s.executables = ["amqp-exchange", "amqp-delexch", "amqp-peek", "amqp-deleteq", "amqp-dequeue", "amqp-unbind", "amqp-statq", "amqp-pop", "amqp-enqueue", "amqp-spy", "amqp-purge"]
  s.extra_rdoc_files = [
    "README.txt"
  ]
  s.files = [
    "History.txt",
    "License.txt",
    "README.txt",
    "Rakefile",
    "TODO.txt",
    "VERSION",
    "amqp-utils.gemspec",
    "bin/amqp-deleteq",
    "bin/amqp-delexch",
    "bin/amqp-dequeue",
    "bin/amqp-enqueue",
    "bin/amqp-exchange",
    "bin/amqp-peek",
    "bin/amqp-pop",
    "bin/amqp-purge",
    "bin/amqp-spy",
    "bin/amqp-statq",
    "bin/amqp-unbind",
    "lib/amqp_utils.rb",
    "lib/amqp_utils/command.rb",
    "lib/amqp_utils/message_formatter.rb",
    "lib/amqp_utils/serialization.rb",
    "test/test_amqp_utils.rb",
    "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/dougbarth/amqp-utils}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{amqp-utils}
  s.rubygems_version = %q{1.4.2}
  s.summary = %q{Command line utilities for interacting with AMQP compliant queues}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<amqp>, ["~> 0.7.1"])
      s.add_runtime_dependency(%q<trollop>, ["~> 1.16.2"])
      s.add_runtime_dependency(%q<facets>, ["~> 2.9"])
      s.add_runtime_dependency(%q<clio>, ["~> 0.3.0"])
      s.add_runtime_dependency(%q<json>, ["~> 1.5"])
      s.add_runtime_dependency(%q<heredoc_unindent>, ["~> 1.1.2"])
      s.add_runtime_dependency(%q<msgpack>, ["~> 0.4.5"])
    else
      s.add_dependency(%q<amqp>, ["~> 0.7.1"])
      s.add_dependency(%q<trollop>, ["~> 1.16.2"])
      s.add_dependency(%q<facets>, ["~> 2.9"])
      s.add_dependency(%q<clio>, ["~> 0.3.0"])
      s.add_dependency(%q<json>, ["~> 1.5"])
      s.add_dependency(%q<heredoc_unindent>, ["~> 1.1.2"])
      s.add_dependency(%q<msgpack>, ["~> 0.4.5"])
    end
  else
    s.add_dependency(%q<amqp>, ["~> 0.7.1"])
    s.add_dependency(%q<trollop>, ["~> 1.16.2"])
    s.add_dependency(%q<facets>, ["~> 2.9"])
    s.add_dependency(%q<clio>, ["~> 0.3.0"])
    s.add_dependency(%q<json>, ["~> 1.5"])
    s.add_dependency(%q<heredoc_unindent>, ["~> 1.1.2"])
    s.add_dependency(%q<msgpack>, ["~> 0.4.5"])
  end
end

