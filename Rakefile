require 'rubygems'

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
