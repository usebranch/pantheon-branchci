# Authenticate with Terminus
terminus auth:login --machine-token=$PANTHEON_MACHINE_TOKEN

# Add the Pantheon Git repository as an additional remote
git remote add pantheon $PANTHEON_GIT_URL

# Push the merge request source branch to Pantheon
git push pantheon $COMMIT_SHA:refs/heads/$BRANCH --force

terminus multidev:create $PANTHEON_SITE.dev $BRANCH
