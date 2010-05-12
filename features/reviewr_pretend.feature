Feature: Pretend Reviewr Execution

  In order to better understand what reviewr is doing
  As a reviewr user/developer
  I want a pretend mode that outputs commands without executing them

  Background:
  Given I am in the working directory of a git repository
  And assuming I enter valid email account information

  Scenario: Pretend Request
    When I run "reviewr -p request reviewer@site.com"
    # There's probably a better way to check this but now I don't care about
    # repo state
    Then I should see "git remote show origin"
