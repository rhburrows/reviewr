Given /^I am in the working directory of a git repository$/ do
  Reviewr::Git.instance.commands = []
  mock_git('git ls-remote origin refs/heads/master',
           'mock refs/heads/master')
  mock_git('git remote show origin',
           'URL: some:site')
end

Given /^my git email is "([^\"]*)"$/ do |email|
  mock_git('git config user.email', email)
end

Given /^the last commit was "([^\"]*)"$/ do |commit|
  mock_git('git show --pretty=format:"%H" HEAD', commit)
end

Given /^the origin is at "([^\"]*)"$/ do |location|
  show_response = <<-END
git help remote* remote origin
  URL: #{location}
  Tracked remote branch
    master
  END
  mock_git('git remote show origin',
           show_response)
end

Given /^the origin master commit is "([^\"]*)"$/ do |commit|
  mock_git('git ls-remote origin refs/heads/master',
           "#{commit}       refs/heads/master")
end

When /^I run "reviewr ([^\"]*)"$/ do |opts|
  Reviewr.run(opts.split(' '))
end

Then /^reviewr should create a new branch called "([^\"]*)"$/ do |name|
  git_executed?("git checkout -b #{name}").should be_true
end

Then /^reviewr should create a commit with message:$/ do |msg|
  last_commit_msg.should == msg
end

Then /^reviewr should push "([^\"]*)" to origin$/ do |branch|
  git_executed?("git push origin #{branch}").should be_true
end

Then /^reviewr should send an email to "([^\"]*)" with body:$/ do |email, body|
  Pony.sent[:to].should == email
  Pony.sent[:body].should == body
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
