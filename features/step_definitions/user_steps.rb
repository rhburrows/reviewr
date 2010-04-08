Given /^assuming I enter valid email account information$/ do
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

When /^I run a reviewr command that requires email$/ do
  @project = reviewr.prompt_for_user(input, output)
end

Then /^I should see "([^\"]*)"$/ do |msg|
  output.messages.should include(msg)
end

Then /^the email should be set to "([^\"]*)"$/ do |email|
  @project.user_email.should == email
end

Then /^the email password should be set to "([^\"]*)"$/ do |pass|
  @project.email_password.should == pass
end
