# Z-aki Tap

This is just upstream fork of https://formulae.brew.sh/formula/emacs#default with native compilation turned on. 

See upstream https://github.com/Homebrew/homebrew-core/pull/98548#issuecomment-1091025084 

Verification of the compilation can be done using `doom doctor` or `M-:` -> `native-comp-available-p` -> it should be `t`, not `nil`.

- https://www.gnu.org/software/emacs/manual/html_node/elisp/Native_002dCompilation-Functions.html#index-native_002dcomp_002davailable_002dp
- https://emacs.stackexchange.com/questions/71282/is-there-a-way-to-determine-if-emacs-uses-the-byte-compiled-or-the-natively-comp

## How do I install these formulae?

`brew install z-aki/tap/emacs`

Or `brew tap z-aki/tap` and then `brew install z-aki/tap/emacs`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "z-aki/tap"
brew "emacs"
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
