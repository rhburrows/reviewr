$:.unshift 'lib'
require 'reviewr'

WORKING_DIR = 'tmp'

$original_dir

Before do
  $original_dir = FileUtils.getwd
  FileUtils.mkdir(WORKING_DIR) unless File.exists?(WORKING_DIR)
  FileUtils.cd(WORKING_DIR)
  File.open('README', 'w') do |f|
    f.write("This directory was created by an automated test " +
            "and should have been deleted when the test completed.\n")
  end
  `git init`
  `git add .`
  `git commit -m "Initial Commit"`
end

After do
  FileUtils.cd($original_dir)
  FileUtils.rm_rf('tmp')
end
