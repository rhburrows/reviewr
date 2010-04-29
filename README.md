# Reviewr: Simple code review

Reviewr is an application to simplify code review for projects using
git and github.com for version control.

# Installation
    gem install reviewr

# Usage

Reviewr is designed to simplify code reviews for projects that revolve
around a single 'master' repository with multiple contributors (i.e. a
project that is hosted on github). It does this by providing a default
work-flow that all developers can use.

The general work-flow (at the moment) is:

1. The coder issues a code review request through the 'request'
command.
2. The reviewer(s) review the code and comment on it through github
3. If the code is good enough to merge it can be pulled into the
master branch through the 'accept' command

While this documentation is up to date (as of version 0.2.0) I am
still experimenting with an ideal work-flow for these type of code
reviews, so this code is subject to heavy change. If you have any
suggestions send me an email or comment in the issue tracker as I
would love further opinions.

## Requesting a code review
    reviewr request <email>
This will result in the following actions:

* Create a code review branch
* Create a commit with information about the code review request
* Push the code review branch to the remote repository
* Send an email to <email> requesting a code review of the branch
  The email will include a link to Github's compare view for the
  changes

## Accepting changes from a code review
    reviewr accept <branch_name>
This will result in the following actions:

* Create a branch for the reviewed code
* Rebase the reviewed code on the current branch
* Merge in the commits
* Push the merged branch
* Delete the code review branch from the remote repo
* Send an email to the requester of the review saying the changes have been
  merged

# Contributing

## Reporting Bugs

Bugs are being managed using Github's issue tracking

http://github.com/rhburrows/reviewr/issues

## Contributing Code

Just fork the project on github and submit a pull request

http://github.com/rhburrows/reviewr

# TODO

## Add a reject code review command

If the code the reviewer is checking is not acceptable, upon finishing
comments on github the reviewer can run `reviewr reject
review_0f38ef31`. reviewr will:

* Re-generate the github url for comparing to the current master
* Send an email to the requester of the review saying the code has
been rejected and to please see the comments on the linked page

# Limitations

* Email can only be sent from a Gmail (or Google Apps for my domain)
  address
* Only tested with git 1.7.0
