# Simplify syncing sgit with GitHub
## Usage
1. set enviromental variable containing a GitHub token with necessary privileges

<code>export GITHUB_TOKEN="YOUR TOKEN"</code>

2. Clone the sgit repo, cd into and run the script

<code>git clone SGIT_REPO<br>
cd SGIT_REPO<br>
sudo -E bash /path/to/gitSync/gitSync.sh
</code>

Or instead do both in one command:
<code>
sudo GITHUB_TOKEN="YOUR TOKEN" bash /path/to/gitSync/gitSync.sh
</code>

Now the repo is on both platforms.

## ToDo:
- Make login to university email automatic, no frequent login prompts

