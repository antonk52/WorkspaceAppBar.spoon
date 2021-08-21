# WorkspaceAppBar.spoon

This is a [Spoon](https://www.hammerspoon.org/Spoons/) to display active apps for workspaces in the menubar.

<img src="https://user-images.githubusercontent.com/5817809/130323429-3ca152fc-9ef5-43d0-8eff-c90c8f538dd2.gif" alt="" style="display: block; margin: auto;">

## Installation

```sh
git clone https://github.com/antonk52/WorkspaceAppBar.spoon ~/.hammerspoon/Spoons/WorkspaceAppBar.spoon
```

## Usage

To enable add the following to your `~/.hammerspoon/init.lua`

```lua
local WorkspaceAppBar = hs.loadSpoon('WorkspaceAppBar')

WorkspaceAppBar.start()
```

Alternatively you can provide options to customize output, below are defaults
```lua
WorkspaceAppBar.start({
    space_delimiter = '  |  ',
    active_space_sign = '*',
})
```

## Known issues

- Does not support multiscreen setup (doable)
- Does not support workspace switch detection via gesture or mission control (needs research)
- No native way to detect workspace switch detection,<br>the spoon relies on default shortcuts <kbd>ctrl</kbd> + <kbd>left</kbd> and <kbd>ctrl</kbd> + <kbd>right</kbd>

## Contributions are welcome

If you know how to improve this spoon open a PR or an issue.
