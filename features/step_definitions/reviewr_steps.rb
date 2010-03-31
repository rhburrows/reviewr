When /^I run "reviewr ([^\"]*)"$/ do |opts|
  @reviewr = Reviewr::CLI::Main.new(opts.split(' '))
  @reviewr.run
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

def git_executed?(cmd)
  Reviewr::Git.instance.commands.include?(cmd)
end

def last_commit_msg
  ci = Reviewr::Git.instance.commands.find{ |c| c =~ /^git commit/ }
  ci.match(/^git commit .+ -m "(.*)"/m)[1].chomp
end
