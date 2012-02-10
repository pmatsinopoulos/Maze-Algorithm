#!/usr/bin/env rake

require "rake"

task :default => :test

require 'rake/testtask'

task :default => :test

desc 'Run unit tests'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
