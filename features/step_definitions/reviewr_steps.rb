Given /^I am in the working directory of a git repository$/ do
  Reviewr::Git.instance.commands = []
end

Given /^my git email is "([^\"]*)"$/ do |email|
  mock_git('git config user.email', email)
end

Given /^the last commit was "([^\"]*)"$/ do |commit|
  mock_git('git show --pretty=format:"%H" HEAD', commit)
end

When /^I run "reviewr ([^\"]*)"$/ do |opts|
  Reviewr.run(opts)
end

Then /^reviewr should create a new branch called "([^\"]*)"$/ do |name|
  git_executed?("git checkout -b #{name}").should be_true
end

Then /^reviewr should create a commit with message:$/ do |msg|
  last_commit_msg.should == msg
end

def mock_git(call, result)
  Reviewr::Git.instance.register(call, result)
end

def git_executed?(cmd)
  Reviewr::Git.instance.commands.include?(cmd)
end

def last_commit_msg
  ci = Reviewr::Git.instance.commands.find{ |c| c =~ /^git commit/ }
  ci.match(/^git commit .+ -m "(.*)"/m)[1].chomp
end
