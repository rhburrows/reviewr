Given /^I am in the working directory of a git repository$/ do
  Reviewr::Git.instance.commands = []
  mock_git('git ls-remote origin refs/heads/master',
           'mock refs/heads/master')
  mock_git('git remote show origin',
           'URL: some:site')
  Given "I am on branch \"master\""
  Given "the last commit was \"aaaaaaaaaaa\""
end

Given /^I am on branch "([^\"]*)"$/ do |branch|
  mock_git('git branch',
           "* #{branch}")
end

Given /^my git email is "([^\"]*)"$/ do |email|
  mock_git('git config user.email', email)
end

Given /^the last commit was "([^\"]*)"$/ do |commit|
  mock_git(%(git show --pretty=format:"%H" HEAD), commit)
end

Given /^the last commit subject was "([^\"]*)"$/ do |commit|
  mock_git(%(git show --pretty=format:"%s" HEAD^), commit)
end

Given /^the last commit body was "([^\"]*)"$/ do |commit|
  mock_git(%(git show --pretty=format:"%b:::::" HEAD^), commit + ":::::")
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

Given /^remote branch "([^\"]*)" won't apply cleanly$/ do |branch|
  mock_git("git rebase master #{branch}",
           [
            "CONFLICT (content): Merge conflict in blah.txt",
            "Failed to merge in the changes.",
            "Patch failed at 0002.",
            "",
            "",
            "When you have resolved this problem run \"git rebase --continue\".",
            "If you would prefer to skip this patch, instead run \"git rebase --skip\".",
            "To restore the original branch and stop rebasing run \"git rebase --abort\"."
           ].join("\n"))
end

Given /^remote branch "([^\"]*)" will apply cleanly$/ do |branch|
  mock_git("git rebase master #{branch}",
           [
            "First, rewinding head to replay your work on top of it...",
            "HEAD is now at 12345679",
            "Applying patch"
           ].join("\n"))
end

Given /^branch "([^\"]*)" has commit "([^\"]*)" beyond master$/ do |branch, commit|
  mock_git("git cherry master #{branch}",
           "+ #{commit}")
end

Then /^reviewr should fetch the branch "([^\"]*)"$/ do |branch|
  git_executed?("git fetch origin #{branch}").should be_true
end

def mock_git(call, result)
  Reviewr::Git.instance.register(call, result)
end
