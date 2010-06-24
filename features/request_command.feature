Feature: Coder users request command to request a code review

  In order to ensure code quality
  As a coder
  I want to send a code review request to another member of my team

  Scenario: Requesting a new code review
    Given I'm on branch "updates"
    And I have commits past branch "master"
    When I run "reviewr request master"
    Then a code review should be created
    And it should be the difference from "master" to "updates"
