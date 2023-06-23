
## Description

It appears when an Audio Unit v3 plug-in's `fullState` property gets set by the host, then if the plug-in goes ahead and generates a new AUParameterTree based on the preset and sets the `self.parameterTree` property the host doesn't get notified about these changes. This causes issues because after a user loads their project/session the automations that they created for the plug-in won't work. This is because the host has a copy of the old parameter tree (e.g. of a default preset). 

The AUM app developer helped me debug this issue. He checked that on his side he wasn't receiving KVO notifications about the refreshed tree. We believe this is a Core Audio API bug.

AUM: https://apps.apple.com/app/aum-audio-mixer/id1055636344

- Feedback ID: FB12427684
- TSI Case-ID: 3075557

## Steps to reproduce it

Visit the following link for the code and screen recordings: https://github.com/Nikolozi/AudioUnitV3Experiments/tree/auparametertree_refresh_issue

On this branch (`auparametertree_refresh_issue`) check out the code for the AUv3MIDIExtension target. What this plug-in does is the following:

1. When the AUAudioUnit subclass (AUv3MIDIDemo.swift) gets created it creates a default parameter tree with parameters named "From Init 1-3".
2. In the `fullState` setter method, a new parameter tree gets created with the parameters named "From fullState 1-3"
3. I don't think these are needed, because I believe the superclass calls these KVOs, but just in case I issue will/didChangeValue KVOs for the parameter tree and the allParameterValues property.
4. In MainView/MainViewModel I have created the parameter tree KVO observer to show that plug-in can see the KVOs of the parameter tree refresh.

I made screen recordings of 3 different hosts with AUv3MIDIExtension showing the issue. I do the following:
1. In an empty session, I instantiate AUv3MIDIExtension plug-in.
2. Both the host and the plug-in see the "From Init 1-3" parameters.
3. I save and reopen the session, at this point, the plug-in sees the refreshed parameters ("From fullState 1-3"), but the hosts still have the old parameters ("From fullState 1-3").

The screen recordings can be found in IssueVideoDemos:
- `IssueVideoDemos/AUM.MP4`
- `IssueVideoDemos/Logic_Pro_for_iPad.MP4`
- `IssueVideoDemos/Logic_Pro_for_Mac.mov`

# What is this?

This is a fork of Apple's [CreatingCustomAudioEffects](https://developer.apple.com/documentation/audiotoolbox/audio_unit_v3_plug-ins/creating_custom_audio_effects) sample code. The primary use case for this repo is to demonstrate possible bugs on Apple platforms or in Logic Pro / GarageBand.

Check the branches to see details of the various issues.

## Compiling
To compile the code, delete `#include "DEVELOPMENT_TEAM.xcconfig"` line in *SampleCode.xcconfig* file and replace it with `DEVELOPMENT_TEAM = XXXXXXXXXX` where `XXXXXXXXXX` is your Apple Developer Team ID.

## Running auval on macOS

For MIDI Plug-in: `auval -v aumi midi Demo`

## Future Plans

Can't be sure.