# CutsceneKit

CutsceneKit is a SpriteKit dependent framework with the goal of providing two core pieces of functionality.

- Provide an event sequence that can run any group of SKActions and allow them to be skipped.
- Add timed hooks to SKVideoNodes that allows them to be skimmed, skipped, and have dialogue overlay.

## Status

Currently in development and not safe for reuse.

## Documentation

Docs are located at [veeneck.github.io/CutsceneKit](http://veeneck.github.io/CutsceneKit) and are generated with [Jazzy](https://github.com/Realm/jazzy). The config file for the documentation is in the project as `config.yml`. Docs can be generated using:

    jazzy --config {PATH_TO_REPOSITORY}/CutsceneKit/CutsceneKit/config.yml

**Note**: The output in the `config.yml` is hard coded to one computer. Edit the file and update the `output` flag to a valid location.
