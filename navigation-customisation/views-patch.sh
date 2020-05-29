#!/bin/bash
# This patches twonky's resources/views/view-definitions.xml file for two changes to the 
# organisation of media in the navigation tree.

# 1/ Use AlbumArtist / Album instead of (Track) Artist / Album in the navigation hierarchies, 
# which in my music collection means that tracks in the same album are more likely to be kept 
# together
# 2/ Group tracks in the same album first by format (eg, .flac, .mp3), and then by file name. 
# This means that even if I have duplicates, when I press play the tracks will play in album 
# order instead of track 1, track 1, track 2, track 2, ...

# Patch 1 requires consistent tagging to work. Patch 2 is generally irrelevant, sometimes 
# helpful and always safe.

# View definitions is easy to restore either by reverting this patch, or copying the orignal
# view-definitions.xml from the original distribution.

# This will create a backup using the -b option
sudo patch -b /opt/twonky/resources/view-definitions.xml < view-definitions.patch
# revert using options -Rb, or copy the view-definitions.xml.orig file back to 
# view-definitions.xml
