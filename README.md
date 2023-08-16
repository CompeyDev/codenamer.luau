<img align="right" height="300" width="300" src="assets/logo.gif" />

# codenamer.luau

A library for generating unique an memorable codenames, inspired by the NPM library [unique-names-generator](https://www.npmjs.com/package/unique-names-generator).

Includes out-of-the-box dictionaries, but custom dictionaries can also be provided for special use-cases.

Uses a simple mullbery32 implementation for pseudorandom number generation under the hood, which makes it unlikely for duplicate codenames in a row.

# Usage
See [examples](/examples) for a variety of examples exploring various functionalities of the library. In order to run a specific example, refer to [development](#development).

# Development
This library is intended to be used with [lune](https://github.com/filiptibell/lune), a standalone Luau runtime. 

Due to the current state of [wally](https://wally.run), installing packages on lune is not successful by default. This project includes a [dependency installation script](/scripts/install-deps.luau), which can be used to set up a development environment. The script is platform independent.

### Running Examples
Once the development environment has been set up, build the minified package bundle by running [bundle-prod.sh](/scripts/bundle-prod.sh). 

Examples can now be run using lune:

```sh
lune examples/EXAMPLE.luau
```

where `EXAMPLE` is to be replaced with the name of the example in the examples directory.
