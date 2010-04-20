Given /^assuming I enter valid email account information$/ do
  Given 'I enter "coder@site.com" for my email'
  Given 'I enter "asdfasdf" for my email password'
  Given 'I use the default remote repository'
end

Given /^I use the default email$/ do
  Given "I enter \"\n\" for my email"
end

Given /^I enter "([^\"]*)" for my email$/ do |email|
  input.email = email
end

Given /^I enter "([^\"]*)" for my email password$/ do |pass|
  input.password = pass
end

Given /^I use the default remote repository$/ do
  Given "I enter \"\n\" for the remote repository"
end

Given /^I enter "([^\"]*)" for the remote repository$/ do |repo|
  input.remote_repo = repo
end

When /^I run a reviewr command that requires email$/ do
  command = reviewr.build_command
  command.input = input
  command.output = output
  command.prompt_for_user
end

Then /^I should see "([^\"]*)"$/ do |msg|
  output.messages.should include(msg)
end

Then /^the email should be set to "([^\"]*)"$/ do |email|
  project.user_email.should == email
end

Then /^the email password should be set to "([^\"]*)"$/ do |pass|
  project.email_password.should == pass
end

Then /^the email server should be set to "([^\"]*)"$/ do |server|
  project.email_server.should == server
end

Then /^the remote repository should be set to "([^\"]*)"$/ do |repo|
  project.remote_repo.should == repo
end

def project
  reviewr.c.project
end
