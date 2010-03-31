Feature: Coder Requests Code Review

  In Order to ensure code quality
  As a coder
  I want to send a review request to another member of my team

  Scenario: Create Review Branch
    Given the last commit was "12345678123456781234567812345678"
    When I run "reviewr request reviewer@site.com"
    Then reviewr should create a new branch called "review_12345678"
