dr-conf
=======

DrConf is a command line tool written in Ruby for syncing config files across machines using remotely hosted git repositories. You can pick and choose which files you watch, and it's up to you when you want to updated those watched files.

### Notes

- It's worth noting when reading the below, whenever the concept of a "path" is mentioned in context to a drconf command, it can either be a file or directory.
- Also, when handing drconf a path prefixed with the `~` the file will be placed relative to the user running drconf when a file is watched.

## Commands

### Init (`drconf init {NAME}`)

Create a local repository with the name given. You can optionally use the `--remote` option to clone a remote repo if you're not starting fresh.

**Examples:**
```bash
drconf init personal
drconf init --remote git@github.com:foo/bar.git company
```

Here we're managing two repos, one for personal files and another for company files.

### List (`drconf list`)

List all repos drconf is aware of.

**Examples:**
```bash
drconf list
```

### Include (`drconf include {PATH} {REPO_NAME}`)

To add a file (or directory) you have locally, but that **isn't** stored in a repository you can use the include command. This will add the local path to the repository specified. If you want to place the given path in a different location in the repository, you can do that with the `--alias` option.

**Examples:**
```bash
drconf include /etc/nginx/nginx.conf personal
drconf include --alias /etc/php/php.ini /etc/php-custom-path/php.ini company
```

In the first example we're simply including the nginx configuration file in the personal repository. In the second example, we have a custom setup for php on this mac, however we'd like to keep it somewhere more general in the repository. The file will be stored in `/etc/php/php.ini` in the repository as specified as an alias.

When including a file, it will automatically watch it. Read below to understand the concept of watching. You can specify `--no-watch` to skip this step.

### Watch (`drconf watch {PATH} {REPO_NAME}`)

The concept of watching a file is faily simple, it's simply telling drconf that you want to sync a path from a repository to your local machine. If the file exists locally, you are required to remove it first.

**Examples:**
```bash
drconf watch ~/.bash_profile company
drconf watch --alias ~/.profile ~/.bash_profile company
```

The first example simply copies the bash profile from the company repository into `~/.bash_profile`. DrConf makes it a little easier to share config files cross platform, in the second example we want to sync our bash profile to the common Mac OSX file `~/.profile`. In a similar fashion to the `include` command you can specify an alias (this is the LOCAL PATH you wish to watch the file to).

### Un-watch (`drconf unwatch {PATH}`)

If you want to un-watch a file it's as simple as using the `unwatch` command and passing in the path. This will remove the file from the "watched" index within drconf but **not** remove the file from the disk.

**Examples:**
```bash
drconf unwatch ~/.bash_profile
```

### Sync (`drconf sync {REPO_NAME}`)

To keep your watched files in sync with the drconf repo, you use the sync command. Here's a brief overview of the behavior;

- If you have local changes and there are no remote changes, your local changes will be commited to the repo
- If you have no local changes and there are remote changes, your local copy will be updated
- If you have local changes and there are remove changes, you must first revert the file so it is unchanged, sync, then apply your changes.

If you have lots of machines and frequent changes to the same files I find it's easier to edit and commit the files to a seperately cloned version of the repo manually, this way you can correctly solve conflicts.

**Examples:**
```bash
drconf sync personal
drconf sync company
```

In the examples above we sync both the personal and company repos.
