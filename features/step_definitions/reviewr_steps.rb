Given /^the review was requested by "([^\"]*)"$/ do |email|
  mock_git('git log -n 1',
           [ "commit 1234567891234567823467",
             "Author: Cody McCoder",
             "Date:   Tue Apr 27 22:35:55 2010 -0700",
             "",
             "Code Review Request",
             "===================",
             "requested_by: coder@site.com",
             "requested_from: reviewer@site.com"
           ].join("\n"))
end

When /^I run "reviewr ([^\"]*)"$/ do |opts|
  reviewr(opts.split(' ')).run
end

Then /^reviewr should create a new branch called "([^\"]*)"$/ do |name|
  git_executed?("git branch #{name} master").should be_true
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

Then /^reviewr should abort the acceptance$/ do
  git_executed?("git rebase --abort").should be_true
end

Then /^reviewr should cherry\-pick commit "([^\"]*)"$/ do |commit|
  git_executed?("git cherry-pick #{commit}").should be_true
end

Then /^reviewr should delete origin branch "([^\"]*)"$/ do |branch|
  git_executed?("git push origin :#{branch}").should be_true
end

def git_executed?(cmd)
  Reviewr::Git.instance.commands.include?(cmd)
end

def last_commit_msg
  ci = Reviewr::Git.instance.commands.find{ |c| c =~ /^git commit/ }
  ci.match(/^git commit .+ -m "(.*)"/m)[1].chomp
end

def reviewr(opts = ['command'])
  @reviewr ||= Reviewr::CLI::Main.new(opts, input, output)
end
