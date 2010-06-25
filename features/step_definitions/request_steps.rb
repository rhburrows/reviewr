Given /^I'm on branch "([^\"]*)"$/ do |branch_name|
  `git checkout -b #{branch_name}`
end

Given /^I have commits past branch "([^\"]*)"$/ do |branch_name|
  File.open('commits-file.txt', 'w') do |f|
    f.write('Some changes to commit')
  end
  `git add .`
  `git commit -m "Another commit"`
end

When /^I run "reviewr ([^\"]*)"$/ do |command|
  Reviewr.start(command.split(' '))
end

Then /^a code review should be created$/ do
  @review = Reviewr::CodeReview.all.last
  @review.should_not be_nil
end

Then /^it should be the difference from "([^\"]*)" to "([^\"]*)"$/ do |from, to|
  from_sha = `git show #{from} -s --pretty=format:%H`
  to_sha = `git show #{to} -s --pretty=format:%H`
  @review.from.should == from_sha
  @review.to.should == to_sha
end

Then /^it should be called "([^\"]*)"$/ do |name|
  @review.name.should == name
end
