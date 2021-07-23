#!/bin/bash

repo=$1
repoName=$(echo "${repo}" | awk -F/ '{print $NF}')

# Exit if any statement fails
set -e

echo "::group::0. Cleanup build directory"
# Don't care if the directory really exists or not
rm -rf "${repoName}" || :
echo "::endgroup::"

echo "::group::1. Clone the repository"
git clone "git@github.com:${repo}.git" --recurse-submodules
cp .env "${repoName}/.env"
cp -a \
  "${repoName}-Production/node_modules" \
  "${repoName}/node_modules" || :
echo "::endgroup::"

echo "::group::2. Install dependencies"
cd "${repoName}"
npm install
echo "::endgroup::"

echo "::group::3. Build"
npm run build
echo "::endgroup::"

echo "::group::4. Kill the server"
# - Don't care if there is really a thing to kill
fuser -k 3000/tcp || :
echo "::endgroup::"

echo "::group::5. Replace the production builds"
cd ..
# Don't care if the production directory really exists or not
rm -rf "${repoName}-Production" || :
mv "${repoName}" "${repoName}-Production"
echo "::endgroup::"

echo "::group::6. Start the server"
cd "${repoName}-Production"
nohup npm start &> ~/logs/log.log &
echo "::endgroup::"

echo "Server Deployed!"