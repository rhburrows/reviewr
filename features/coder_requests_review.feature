Feature: Coder Requests Code Review

  In Order to ensure code quality
  As a coder
  I want to send a review request to another member of my team

  Background:
  Given I am in the working directory of a git repository
  And assuming I enter valid email account information

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

  Scenario: Send an email with commit info and a github compare URL
    Given the last commit was "12345678123456781234567812345678"
    And the last commit subject was "Added subject to reviewr email"
    And the last commit body was "Now you will see commit info in the review request"
    And the origin is at "git@github.com:rhburrows/reviewr.git"
    And the origin master commit is "87654321876543218765432187654321"
    When I run "reviewr request reviewer@site.com"
    Then reviewr should send an email to "reviewer@site.com"
     And the subject of the sent email should be: "Code review request: Added subject to reviewr email"
     And the body of the sent email should be:
    """
    Now you will see commit info in the review request

    http://github.com/rhburrows/reviewr/compare/87654321...12345678

    Accept:
      reviewr accept review_12345678
    Reject:
      reviewr reject review_12345678

    Thanks!

    """
