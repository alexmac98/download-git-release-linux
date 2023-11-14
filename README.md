# download-git-release-linux
A bash script to download assets from a given release of a public/private GitHub repository you have access to.
Only tested in Linux (Ubuntu 20.04).

# Setup:
Edit download-release.sh and update the variables:
- GITHUB_USER_ORGANIZATION;
- GITHUB_REPOSITORY;
- GITHUB_API_TOKEN;
- ASSET_NAME;
  
with the needed information.

# Usage:
$ ./download-release.sh \<tag\>
