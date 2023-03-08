# What is this?

This is a fork of Apple's [CreatingCustomAudioEffects](https://developer.apple.com/documentation/audiotoolbox/audio_unit_v3_plug-ins/creating_custom_audio_effects) sample code. Primary use case for this repo is to demonstrate possible bugs on Apple platforms or in Logic Pro / GarageBand.

Check the branches to see details of the various issues.

## Compiling
To compile the code, delete `#include "DEVELOPMENT_TEAM.xcconfig"` line in *SampleCode.xcconfig* file and replace it with `DEVELOPMENT_TEAM = XXXXXXXXXX` where `XXXXXXXXXX` is your Apple Develope Team ID.

## Running auval on macOS

For MIDI Plug-in: `auval -v aumi midi Demo`

## Future Plans

Can't be sure.