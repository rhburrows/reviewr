Given /^I am in the working directory of a git repository$/ do
  Reviewr::Git.instance.commands = []
  mock_git('git ls-remote origin refs/heads/master',
           'mock refs/heads/master')
  mock_git('git remote show origin',
           'URL: some:site')
  mock_git('git branch',
           '* master')
  Given "the last commit was \"aaaaaaaaaaa\""
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

Given /^remote branch "([^\"]*)" won't apply cleanly$/ do |branch|
  mock_git("git rebase origin/master #{branch}",
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

Then /^reviewr should fetch the branch "([^\"]*)"$/ do |branch|
  git_executed?("git fetch origin #{branch}").should be_true
end

def mock_git(call, result)
  Reviewr::Git.instance.register(call, result)
end
