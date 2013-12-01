#!/bin/bash

# script for renaming harbour-helloworld-pro-sailfish into whatever you want you project to be

# Check if input is correct

# Replace text and rename files in the same cycle

EXPECTED_ARGS=1

if [[ $# -ne $EXPECTED_ARGS ]]; then
  echo "Usage: $(basename $0) harbour-my-cool-app-name"
  exit
fi

newname=$1
if [[ $newname != harbour-* ]]; then
  echo Your new app name MUST start with \"harbour-\"
  exit
fi

echo Replacing "harbour-helloworld-pro-sailfish" with "$newname"
# iterating over all files except for the binary ones
# First rename files
for fl in $(find .  -name .git -prune -o -type f -name 'harbour-helloworld-pro-sailfish*' -print); do
    echo Updating to ${fl/harbour-helloworld-pro-sailfish/$newname}
    mv $fl ${fl/harbour-helloworld-pro-sailfish/$newname}
done

# Then do substitutions
for fl in $(find . -name .git -prune -o -type f -print | xargs file | grep ASCII | cut -d: -f1); do
    # Ignore this particular file and everything inside .git dir
    if [[ "$fl" =~ "rename-to-my-project.sh" ]]; then
        continue
    fi
    if sed -i "s/harbour-helloworld-pro-sailfish/$newname/g" $fl; then
	echo Updated $fl
    fi
done
echo Done. Enjoy your $newname app!
