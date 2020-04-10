# Alpha Coder
A programming blog by Nicholas Kajoh built with Hugo. Visit [alphacoder.xyz/blog](http://alphacoder.xyz/blog).

## Setup
- Install [Hugo](https://gohugo.io/getting-started/installing).
- Clone repo `git clone --recurse-submodules https://github.com/nicholaskajoh/alphacoder.xyz`.
- Run Hugo server `hugo server -D`.

## Publish on GitHub Pages
- Run `git worktree add -B gh-pages public origin/gh-pages` once.
- Run `chmod +x ./publish.sh && ./publish.sh`.

## Update theme to latest
- Run `git submodule update --recursive --remote`.