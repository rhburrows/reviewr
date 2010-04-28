Feature: Code Reviewer accepts changes

  In order to apply good code to my codebase consistently
  As a code reviewer
  I want reviewr to merge in the changes that I designate

  Background:
  Given I am in the working directory of a git repository
  And assuming I enter valid email account information

  Scenario: Reviewr fetches remote branch
    When I run "reviewr accept review_12345678"
    Then reviewr should fetch the branch "review_12345678"

  Scenario: Reviewr rejects changes if they don't apply cleanly
    Given remote branch "review_12345678" won't apply cleanly
    When I run "reviewr accept review_12345678"
    Then reviewr should abort the acceptance
    And I should see "Branch 'review_12345678' won't merge cleanly"

  Scenario: Reviewr cherry-picks commits if they apply cleanly
    Given remote branch "review_12345678" will apply cleanly
    And I am on branch "master"
    And branch "review_12345678" has commit "12345678123456781234567812345678" beyond master
    When I run "reviewr accept review_12345678"
    Then reviewr should cherry-pick commit "12345678123456781234567812345678"

  Scenario: Reviewr pushes the merged branch to the remote repository
    Given remote branch "review_12345678" will apply cleanly
    And I am on branch "master"
    When I run "reviewr accept review_12345678"
    Then reviewr should push "master" to origin

  Scenario: Reviewr deletes the code review branch
    Given remote branch "review_12345678" will apply cleanly
    And I am on branch "master"
    When I run "reviewr accept review_12345678"
    Then reviewr should delete origin branch "review_12345678"
