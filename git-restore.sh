#!/bin/sh
#
# Restore specified files from last known commit in a git repo.
# Based on
# <http://stackoverflow.com/questions/953481/restore-a-deleted-file-in-a-git-repo>
#
# Copyright (C) 2013 Richard Mortier <mort@cantab.net>.  All Rights
# Reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
# USA.

set +ex

restore ()
{
    ## ok, so the last $1 in the `git checkout` below was originally
    ##   $(git diff --name-status $REV | grep "^D.*$1$" | cut -f 2)
    ## which makes little sense to me: it sort-of canonicalises the filename
    ## with a directory, or at least, the first instance of a file of that name
    ## in the directory listing -- but surely you really want the instance
    ## specified by the user, ie., just $1 ?!

    git checkout $(git rev-list -n 1 HEAD -- $1)~1 -- $1
    git add $1
}

for f in $@ ; do
    echo $f && restore $f
done
