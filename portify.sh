#!/usr/bin/env sh

# Script to make a virtual env essentially portable. Rewrites shebangs and
# modifies the VIRTUAL_ENV root folder.

PORTIFIED_WATERMARK="# portified"
grep "$PORTIFIED_WATERMARK" $1/bin/activate && exit()

# We only need to portify once.
echo "$PORTIFIED_WATERMARK" >> $1/bin/activate

# Modify the shebang of all scripts on each activation
echo "find \$VIRTUAL_ENV -type f -print0 | \
      xargs -0 sed -i '1s/#!.*python/#!\/usr\/bin\/env python/'" \
      >> $1/bin/activate

# Makes activate portable in bash & zsh
sed -i 's/VIRTUAL_ENV=.*/VIRTUAL_ENV="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")")" \&\& pwd)"/' \
  $1/bin/activate
