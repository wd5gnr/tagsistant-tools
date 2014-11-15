# tagsistant utilities are bash scripts that work
#  with tagsistant (www.tagsistant.net)
#
# Copyright (C) 2014 Al Williams (al.williams@awce.com)
#

The scripts assume you have TAGROOT set in the environment
-or- specify it on the command line for tag and tagmerge
-or- you use ~/files as your tagged system root


tag - Tag one or more files 
tag by Al Williams (al.williams@awce.com)
Usage:
tag [-r tag_root_directory] [-h] [-d] [-m] [-n] [-v] tag file [file...]
or
tag [-r tag_root_directory] [-h] [-d] [-m] [-n] [-v] -t tag file [file...]

If the tag starts with an @ it will be removed. That is:
  tag foo myfile.txt

Tags myfile.txt with foo, but:
  tag @foo myfile.txt

Removes the tag. This is not allowed with the -t option

-r (--tag-root) Sets the target directory
-t (--tag) Add tag (must exist; multiple -t options allowed and encouraged)
-h (--help) Shows this message (or any bad option)
-m (--move) Moves files from external file system instead of copies
   (Tagging an already tagged file always uses move and preserves tags)
-n (--no-new-tag) Prevents creating new tags (always set if using -t)
-v Verbose mode (for debugging)
-d (--dry-run) Don't actually do anything, just print what would happen

Note: calling the script as untag (via a link, for example) always
treats the tag as @tag unless called as untag


tagmerge - Merge two tags
tagmerge is a bash script to work with tagsistant (http://www.tagsistant.net)

Version 1.0 13 Nov 2014
Copyright (C) 2014 Al Williams (al.williams@awce.com)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

tagmerge by Al Williams (al.williams@awce.com)
Usage:
tagmerge [-r tag_root_directory] [-h] [-d] [-k] [-v] from_tag to_tag

-r (--tag-root) Sets the target directory
-h (--help) Shows this message (or any bad option)
-k (--keep-tag) Don't delete tag when done
-v Verbose mode (for debugging)
-d (--dry-run) Don't actually do anything, just print what would happen


# Really dumb scripts below

tagls - Show files that have a tag or a list of tags

tagq - Dump the tags for a given file






# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

