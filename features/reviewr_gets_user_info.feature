Feature: Reviewr gets user information

  So that Emails are sent properly and from the correct persson
  As a user of reviewr
  I want to be prompted for my email information/password when I run the program

  Background:
  Given I am in the working directory of a git repository

  Scenario: Reviewr asks for email but sets a reasonable default
    Given my git email is "coder@site.com"
    When I run a reviewr command that requires email
    Then I should see "Email (default coder@site.com): "

  Scenario: Reviewr defaults email if I don't set one
    Given my git email is "coder@site.com"
    And I use the default email
    When I run a reviewr command that requires email
    Then the email should be set to "coder@site.com"

  Scenario: Reviewr accepts the email that I enter
    Given my git email is "wrong@site.com"
    And I enter "me@site.com" for my email
    When I run a reviewr command that requires email
    Then the email should be set to "me@site.com"

  Scenario: Reviewr asks for email password
    When I run a reviewr command that requires email
    Then I should see "Email password: "

  Scenario: Reviewr takes the password I enter
    Given I enter "asdfasdf" for my email password
    When I run a reviewr command that requires email
    Then the email password should be set to "asdfasdf"
