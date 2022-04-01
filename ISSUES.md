# ISSUES

Use this file to list and control issues/tickets/features/to-dos. In two words, project management.

(At this moment, we prefer to use an ISSUES file instead of any specific project management tool.)

Possible values for status: OPEN, COMPLETE, IGNORED, ONGOING.

## ISSUE #0001 COMPLETE

There is a determined process for git branching, and it is consistent
with versioning (done with git tags).
The versioning is X.Y.Z, following the major/minor/patch convention,
with occasional appendices to convey alpha, beta, rc, etc.
There two long-lived branches, called "master" and "develop",
with the first tracking at all moments the best shipped version and the second
centralizing the process of fixing bugs and creating features (and also
of creating bugs).
This includes a separate short-lived branch for each issue while in development
(if it warrants a separate branch), for example issue-0001, and also a
separate branch for each minor release (for example release-0.1) containing
the relevant commits tagged with their version numbers (v0.1.0, v0.1.0-alpha, etc.).
Some of what is done in the release branches (for example, hotfixes)
may be merged back into the develop branch.
Also, the informal version of any build in the develop branch is defined
to be X.Y.Z+dev, where X.Y.Z is the latest release.
The RELEASES file records the changes between the versions.

## ISSUE #0002 OPEN

Maybe move the code files one folder deeper to separate from builds
and project-related files.

## ISSUE #0003 OPEN

Within project code, maybe separate assets and code better, sending code
one folder deeper.

## ISSUE #0004 COMPLETE

Game has a web version which can be played in any web-capable (more
precisely HTML5-supporting) device through its GitHub Pages. Files of
this build are in folder /docs/.
