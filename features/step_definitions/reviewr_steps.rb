Given /^the last commit was "([^\"]*)"$/ do |commit|
  Reviewr::Git.instance.register('git show --pretty=format:"%H" HEAD',
                                 commit)
end

When /^I run "reviewr ([^\"]*)"$/ do |opts|
  Reviewr.run(opts)
end

Then /^reviewr should create a new branch called "([^\"]*)"$/ do |name|
  Reviewr::Git.instance.commands.should include("git co -b #{name}")
end
