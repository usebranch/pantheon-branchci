# Authenticate with Terminus
terminus auth:login --machine-token=$PANTHEON_MACHINE_TOKEN

# Add the Pantheon Git repository as an additional remote
git remote add pantheon $PANTHEON_GIT_URL

# Push the merge request source branch to Pantheon
git push pantheon $COMMIT_SHA:refs/heads/$BRANCH --force

# Create a function for determining if a multidev exists
TERMINUS_DOES_MULTIDEV_EXIST()
{
    # Stash a list of Pantheon multidev environments
    PANTHEON_MULTIDEV_LIST="$(terminus multidev:list ${PANTHEON_SITE} --format=list --field=id)"

    while read -r multiDev; do
        if [[ "${multiDev}" == "$1" ]]
        then
            return 0;
        fi
    done <<< "$PANTHEON_MULTIDEV_LIST"

    return 1;
}

# If the mutltidev doesn't exist
if ! TERMINUS_DOES_MULTIDEV_EXIST $BRANCH
then
    # Create it with Terminus
    echo "No multidev for $BRANCH found, creating one..."
    terminus multidev:create $PANTHEON_SITE.dev $BRANCH
else
    echo "The multidev $BRANCH already exists, skipping creating it..."
fi
