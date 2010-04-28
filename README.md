# Reviewr: Simple code review

Reviewr is an application to simplify code review for projects using
git and github.com for version control.

# Installation
    gem install reviewr

# Requesting a code review
    reviewr request <email>
This will result in the following actions:

* Create a code review branch
* Create a commit with information about the code review request
* Push the code review branch to the remote repository
* Send an email to <email> requesting a code review of the branch
  The email will include a link to Github's compare view for the
  changes

# Accepting changes from a code review
    reviewr accept <branch_name>
This will result in the following actions:

* Create a branch for the reviewed code
* Rebase the reviewed code on the current branch
* Merge in the commits
* Push the merged branch
* Delete the code review branch from the remote repo
* Send an email to the requester of the review saying the changes have been
  merged

## Limitations

* Email can only be sent from a Gmail (or Google Apps for my domain)
  address

# TODO

## Finish out the basic workflow

General workflow goes something like this:

Code, code, code. Decide changes are ready for review and run `reviewr
request email@site.com`. This causes reviewr to:

* create a new branch with the name `review_0f38ef31` where `0f38ef31`
is the SHA of the current commit
* Add a commit to the branch with metadata about the request
(requester name/email etc). 
* push the branch to the origin repository
* generate a github review url from the current head to the pushed
review branch
* Send an email to `email@site.com` with a nice message and the url

The reviewer then looks over the code on github and comments as
necessary. If the code is acceptable the reviewer runs `reviewr accept
review_0f38ef31`. reviewr will then:

* fetch the review branch
* attempt to merge the reviewed branch into the master
* if it fails an error will be raised and execution will stop
* if is succeeds the merged master will be pushed
* the remote review branch will be deleted.
* an email will be sent to the review requester saying the code was accepted

If the code the reviewer is checking is not acceptable, upon finishing
comments on github the reviewer can run `reviewr reject
review_0f38ef31`. reviewr will:

* Re-generate the github url for comparing to the current master
* Send an email to the requester of the review saying the code has
been rejected and to please see the comments on the linked page
