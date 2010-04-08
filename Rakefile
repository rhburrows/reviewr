require 'rubygems'

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'reviewr/version'

begin
  require 'cucumber'
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--format pretty"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :cucumber do
    abort 'Install cucumber as a gem to run tests.'
  end
end

begin
  require 'spec/rake/spectask'

  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
  end
rescue LoadError
  desc 'RSpec rake task not available'
  task :spec do
    abort 'Install rspec as a gem to run tests.'
  end
end

desc 'Build the reviewr gem'
task :build do
  system "gem build reviewr.gemspec"
end

desc 'Push a the gem to gemcutter'
task :release => :build do
  system "gem push reviewr-#{Reviewr::VERSION}.gem"
end
