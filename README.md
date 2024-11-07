# Simplify syncing sgit with GitHub
## Setup

1. Change the GitHub Username in the <code>gitSync.sh</code>

2. Set enviromental variable containing a GitHub token with necessary privileges

<code>export GITHUB_TOKEN="YOUR TOKEN"</code>


## Usage

Clone the sgit repo, cd into and run the script

<code>git clone SGIT_REPO<br>
cd SGIT_REPO<br>
sudo -E bash /path/to/gitSync/gitSync.sh
</code>


Instead of setting the enviromental variable for the GitHub token, you can set it within the command:
<code>
sudo GITHUB_TOKEN="YOUR TOKEN" bash /path/to/gitSync/gitSync.sh
</code>

Now the repo is on both platforms.


## ToDo:
- Make login to university email automatic, no frequent login prompts
- Dynamically set GitHub username
