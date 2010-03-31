
# Ideas

General workflow goes something like this:

Code, code, code. Decide changes are ready for review and run `reviewr
request email@site.com`. This causes reviewr to:

* create a new branch with the name `review_0f38ef31` where `0f38ef31`
is the SHA of the current commit
* Add a commit to the branch with metadata about the request
(requester name/email etc). 
* push the branch to the origin repository
* generate a github review url from the current master head commit to
the pushed review branch
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

# Questions and problems

* History of comments when be lost when commits are merged

# Todo

* Update this when complete to be a README not a ideas page
