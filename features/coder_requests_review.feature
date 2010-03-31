Feature: Coder Requests Code Review

  In Order to ensure code quality
  As a coder
  I want to send a review request to another member of my team

  Background:
  Given I am in the working directory of a git repository

  Scenario: Create Review Branch
    Given the last commit was "12345678123456781234567812345678"
    When I run "reviewr request reviewer@site.com"
    Then reviewr should create a new branch called "review_12345678"

  Scenario: Add a meta-data commit to the review branch
    Given my git email is "coder@site.com"
    And the last commit was "12345678123456781234567812345678"
    When I run "reviewr request reviewer@site.com"
    Then reviewr should create a commit with message:
    """
    Code Review Request
    ===================
    requested_by: coder@site.com
    requested_from: reviewer@site.com
    """

  Scenario: Push the review branch to the origin
    Given the last commit was "12345678123456781234567812345678"
    When I run "reviewr request reviewer@site.com"
    Then reviewr should push "review_12345678" to origin

  Scenario: Send an email with a github compare URL
    Given the last commit was "12345678123456781234567812345678"
    And the origin is at "git@github.com:rhburrows/reviewr.git"
    And the origin master commit is "87654321876543218765432187654321"
    When I run "reviewr request reviewer@site.com"
    Then reviewr should send an email to "reviewer@site.com" with body:
    """
    Hi,

    Could you please code review and comment on the following changes:

    http://github.com/rhburrows/reviewr/compare/87654321...12345678

    If you find the changes acceptable please run:
      reviewr accept review_12345678
    If you think more work needs to be done please run:
      reviewr reject review_12345678

    Thanks!

    """
