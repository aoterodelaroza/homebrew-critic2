# Homebrew tap for critic2

This repository is a [Homebrew](https://brew.sh) tap for
[critic2](https://aoterodelaroza.github.io/critic2/), a program for the
analysis of quantum-chemical and crystallographic data in molecules and
solids. It installs the latest critic2 release, including the graphical
interface, together with all its dependencies. On Apple Silicon Macs with
macOS 14 or newer and Intel Macs with macOS 15 or newer, Homebrew downloads
a prebuilt critic2 (a "bottle"); on older systems it compiles it.

## Installation

1. Install Homebrew, if you do not have it already, and follow the "Next
   steps" it prints at the end (they add Homebrew to your `PATH`). The
   installer also installs Apple's command line tools if they are missing:

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Install critic2:

   ```sh
   brew install aoterodelaroza/critic2/critic2
   ```

   Homebrew adds this tap automatically, then downloads critic2 and the
   libraries it depends on (gcc's runtime, libxc, openblas, hdf5, glfw, ...).

To install the current development version (the `master` branch of the
[critic2 repository](https://github.com/aoterodelaroza/critic2)) instead,
compiling it on your machine, use
`brew install --HEAD aoterodelaroza/critic2/critic2`.

macOS does not show any "unidentified developer" warning when you run
critic2: Homebrew installs it without the quarantine flag that triggers
that check.

## Usage

critic2 is used from the terminal (Terminal.app, iTerm2, ...) in the same
way as on Linux. The program is driven by an input file with keywords
(usually with extension `.cri`):

```sh
critic2 input.cri              # output to the screen
critic2 input.cri output.cro   # output to a file
critic2                        # interactive mode; exit with "end" or Ctrl-D
```

To start the graphical interface, optionally opening one or more files:

```sh
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

  ```sh
  export OMP_NUM_THREADS=4
  ```

- **Size of the GUI.** The interface is sized according to the display
  scale. To make it larger or smaller, set the `CRITIC2_UI_SCALE` variable:

  ```sh
  CRITIC2_UI_SCALE=1.25 critic2 -g
  ```

- **Editing input files.** Use a plain-text editor. TextEdit in its default
  (rich text) mode replaces straight quotes with curly quotes and saves rich
  text, which critic2 cannot read; switch it to Format > Make Plain Text if
  you use it.

## Updating and uninstalling

```sh
brew upgrade                               # update critic2 (and everything else)
brew uninstall critic2                     # remove critic2
brew untap aoterodelaroza/critic2          # remove this tap
```

If you installed the development version with `--HEAD`, use
`brew upgrade --fetch-HEAD critic2` to rebuild it with the latest commits.

## Troubleshooting

If the installation fails, the build logs are in
`~/Library/Logs/Homebrew/critic2/`. Please, report problems at the
[critic2 issue tracker](https://github.com/aoterodelaroza/critic2/issues),
attaching the logs and the output of `brew config`.


## Releasing a new version (maintainers)

1. Tag the release in the critic2 repository and publish the GitHub release
   (its own workflow builds the Windows and Linux packages).
2. Here, on a new branch, point the formula at the tag and push the branch:

   ```sh
   git switch -c critic2-<tag>
   ./bump.sh <tag>
   git commit -am "critic2 <tag>" && git push -u origin critic2-<tag>
   ```

3. Open a pull request. The `brew test-bot` workflow builds and tests the
   bottles on macOS 14 (Apple Silicon) and macOS 15 (Intel).
4. When it passes, run the `brew pr-pull` workflow (Actions tab, "Run
   workflow", with the pull request number). It uploads the bottles to the
   GitHub Packages of this repository, adds the `bottle do` block to the
   formula, pushes to `main`, and closes the pull request. Users get the
   new version with `brew upgrade`.

The first time bottles are published, check in the repository's Packages
settings that the `critic2` package is public; otherwise `brew install`
cannot download it.
