# Homebrew tap for critic2

This repository is a [Homebrew](https://brew.sh) tap for
[critic2](https://aoterodelaroza.github.io/critic2/), a program for the
analysis of quantum-chemical and crystallographic data in molecules and
solids. The formula builds critic2 from source on your Mac, including the
graphical interface, and installs it together with all its dependencies.
It works on Apple Silicon and Intel Macs.

## Installation

1. Install the Xcode Command Line Tools (compilers, git, the macOS SDK), if
   you do not have them already:

   ```
   xcode-select --install
   ```

2. Install Homebrew, if you do not have it already, and follow the "Next
   steps" it prints at the end (they add Homebrew to your `PATH`):

   ```
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. Install critic2:

   ```
   brew install aoterodelaroza/critic2/critic2
   ```

   Homebrew adds this tap automatically and compiles critic2 on your
   machine. The first installation takes a while, mostly to fetch the
   compilers and libraries critic2 depends on (gcc, libxc, openblas,
   hdf5, glfw, ...). Later updates are much faster.

The formula always builds the current version of critic2 (the `master`
branch of the [critic2 repository](https://github.com/aoterodelaroza/critic2)).

Because critic2 is compiled on your own machine, macOS does not show any
"unidentified developer" warning when you run it.

## Usage

critic2 is used from the terminal (Terminal.app, iTerm2, ...) in the same
way as on Linux. The program is driven by an input file with keywords
(usually with extension `.cri`):

```
critic2 input.cri              # output to the screen
critic2 input.cri output.cro   # output to a file
critic2                        # interactive mode; exit with "end" or Ctrl-D
```

To start the graphical interface, optionally opening one or more files:

```
critic2 -g
critic2 -g structure.cif
```

Run the GUI from a terminal on the Mac's own screen (it cannot be opened
through an ssh session).

See the [critic2 manual](https://aoterodelaroza.github.io/critic2/) for the
input syntax and the list of keywords.

Some notes:

- **Data files.** There is no need to set `CRITIC_HOME`: critic2 finds its
  data files (atomic densities, structure library, ...) in the Homebrew
  installation automatically.

- **Parallel runs.** critic2 is parallelized with OpenMP. Apple Silicon
  chips have performance and efficiency cores; in general, it is best to use
  as many threads as performance cores (4 on an M1). Add, for instance, to
  your `~/.zprofile`:

  ```
  export OMP_NUM_THREADS=4
  ```

- **Size of the GUI.** The interface is sized according to the display
  scale. To make it larger or smaller, set the `CRITIC2_UI_SCALE` variable:

  ```
  CRITIC2_UI_SCALE=1.25 critic2 -g
  ```

- **Editing input files.** Use a plain-text editor. TextEdit in its default
  (rich text) mode replaces straight quotes with curly quotes and saves rich
  text, which critic2 cannot read; switch it to Format > Make Plain Text if
  you use it.

## Updating and uninstalling

```
brew update && brew reinstall critic2      # rebuild with the current critic2
brew uninstall critic2                     # remove critic2
brew untap aoterodelaroza/critic2          # remove this tap
```

Use `brew reinstall`, not `brew upgrade`, to update critic2: the version
number in the formula does not change with every new commit, so
`brew upgrade` does not see that there is anything new.

## Troubleshooting

If the installation fails, the build logs are in
`~/Library/Logs/Homebrew/critic2/`. Please, report problems at the
[critic2 issue tracker](https://github.com/aoterodelaroza/critic2/issues),
attaching the logs and the output of `brew config`.

