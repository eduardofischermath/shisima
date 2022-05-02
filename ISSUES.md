# ISSUES

Use this file to list and control issues/tickets/features/to-dos. In two words, project management.

(At this moment, we prefer to use an ISSUES file instead of any specific project management tool.)

Possible values for status: OPEN, COMPLETE, IGNORED, ONGOING.

## ISSUE #0001 COMPLETE

There is a determined process for git branching, and it is consistent
with versioning (done with git tags).
The versioning is X.Y.Z, following the major/minor/patch convention,
with occasional appendices to convey prep, alpha, beta, rc, etc.
There one long-lived branch called "develop", centralizing the process
of fixing bugs and creating features (and also of creating bugs).
This includes a separate short-lived branch for each issue while in development
(if it warrants a separate branch), for example issue-XYZW, and also a
separate branch for each minor release (for example release-X.Y) containing
the relevant commits tagged with their version numbers (vX.Y.Z, vX.Y.Z-alpha,
etc.) when such tagging is convenient.
Most of what is done in the release branches (for example, hotfixes,
release notes) could likely be merged back into the develop branch.
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
this build (achieved using Godot) are in folder /docs/.

## ISSUE #0005 OPEN

When game is finished with victory (three pieces aligned), make an animation
(like pieces on fire), or otherwise sinalize it to the user somehow.

## ISSUE #0006 OPEN

Allow a "reset" button which brings a Shisima game to its initial state,
and can be pressed during a game or after its conclusion.

## ISSUE #0007 OPEN

Implement draw, in which a repeated position (three times, for example,
or configurable) leads to a draw in the Shisima game.

## ISSUE #0008 OPEN
In addition to clicking, allow player to move pieces by dragging them.
(For example, this might be chosen at the start of a Shisima game.)

## ISSUE #0009 OPEN
Allow for different human "controllers". By that we mean a choice of
input methods for local multiplayer. For example, one can use the mouse
while the other uses the keyboard (the key name appears on the arrow as
an overlay).

## ISSUE #0010 OPEN
Allow computer engines with differing strategies (and thus difficulties)
to control the pieces of a Shisima player.

## ISSUE #0011 OPEN
Can also add fictitious pictures and personalities to engine players.

## ISSUE #0012 OPEN
Create a career mode, in which a human player has to challenge multiple
engines, sequentially, to win. Similar to how Mortal Kombat operates.

## ISSUE #0013 OPEN
Create a rules screen, destination of corresponding button on splash screen.

## ISSUE #0014 OPEN
Create an options screen.

## ISSUE #0015 OPEN
Create a "pause" menu, with Resume, Restart, Rules, Options and Quit buttons.

## ISSUE #0016 OPEN
Create external interface to allow an external program to interact (send
and receive moves) with the program. This is useful for training an
Artificial Intelligence, or plugging one to see how it performs.

## ISSUE #0017 OPEN
Develop an invincible AI to the game, preferably through some machine
learning technique. Engines using "if-then" programming and strict
brute-forcing are also acceptable for this end.
