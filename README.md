# svn2git
Shell scripts to migrate SVN repositories to Git
 

## Migrating an SVN Repository to Git ([subversion-git-migration](https://unfuddle.com/stack/docs/help/subversion-git-migration/))


### Gathering User Information

```shell
	svn co REPOPATH repo
	cd repo
	svn log -q | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u > authors-transform.txt
```
This will create authors-transform.txt with all the committers from the SVN repository specified by REPOPATH with dummy Git committer information, such as:

```
	$ svn_committer = svn_committer <USER@DOMAIN.COM>
```
Once this is done, you can edit the file, and enter in each users actual name and email address on the right side of the equals sign. This will be the Git author information used during the migration.

### Cloning the SVN Repository

Once your user mapping is completed, you can now clone the SVN repository directly using git svn clone.
```
	$ git svn clone [subversion_repository_url] --stdlayout --no-metadata -A authors.txt ./repo
```

### Cleaning Up

If you had tags in the SVN repository, these are now remote branches for each tag. To display these you will want to run:
```
	$ cd /path/to/repo
	$ git branch -r
```	
For each tag displayed you will want to run:
```
	$ git tag tagname tags/tagname
	$ git branch -r -d tags/tagname
```

#### Deleting trunk branch
If you don't want to get svn trunk as a Git branch, you will want to run:
```	
	git branch -r -d origin/trunk
```	

### Pushing to Origin
Congratulations! You have created a Git repository with all the history, and authors set correctly. Now, we are on to the last step. You will want to push the Repository up to Origin so it is available to other users in the account. If you haven't already created an empty Git repository in your account, do that now. Then follow these commands:
```
	$ cd /path/to/repo
	$ git remote add origin https://subdomain.unfuddle.com/git/subdomain_abbreviation/
	$ git push origin master
	$ git push --tags
```
Now this repository can be accessed by users in the project simply by cloning the repository using git clone. Enjoy using Git!

#### Pushing branches to Origin
[From stackoverflow:](http://stackoverflow.com/questions/6865302/push-local-git-repo-to-new-remote-including-all-branches-and-tags)

So you have your repository and all the branches inside, but you still need to checkout those branches for the ``git push --all`` command to actually push those too.

You should do this before you push:
```shell
	for remote in `git branch -r | grep -v master `; do git checkout --track $remote ; done
```
Followed by
```shell
	git push --all
```    
    
## Notes
Some useful commands to filter branches

### Filter tag branches
```shell
	for remote in `git branch -r | grep tags `; do echo $remote ; done
```
### Filter tag branch names
```shell
	for remote in `git branch -r | grep tags `; do echo $remote | sed 's/.*\///' ; done
```
