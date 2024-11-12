let carapace_completer = {|spans|
    carapace $spans.0 nushell $spans | from json
}

$env.config = {
    show_banner: false,
    completions: {
        case_sensitive: false # case-sensitive completions
        quick: true    # set to false to prevent auto-selecting completions
        partial: true    # set to false to prevent partial filling of the prompt
        algorithm: "fuzzy"    # prefix or fuzzy
        external: {
            # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true 
            # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100 
            completer: $carapace_completer # check 'carapace_completer' 
        }
    }
} 

# Some git commands
# gb - lists git branches including last commit, sorts by commit date.
def gb [...params] { 
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) | %(committerdate:iso8601) | %(authorname) | %(contents:subject)' ...$params | 
  lines | 
  split column " | " name lastCommitDate author commitMessage | 
  sort-by lastCommitDate 
}

def gl [count: int = 10, ...rest] { 
  git log -n $count --pretty=format:"%h | %ad | %an | %p | %s%d" --date=iso-local ...$rest | 
  lines | 
  split column " | " commitHash dateTime author mergeDetails commitTitle refs 
}

$env.PATH = ($env.PATH | 
    split row (char esep) |
    prepend /home/cwilliams/.apps |
    append /usr/bin/env
)

