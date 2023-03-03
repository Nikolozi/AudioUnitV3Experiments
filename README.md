# Issue Details

## Update 
I have submitted Developer Technical Support (DTS) regarding this issue and I received a reply to file a bug report. Case-ID: 1674516

Feedback ID is: FB12029567


## Description

The `aumf / kAudioUnitType_MusicEffect` type of AUv3 plug-in is not appearing in Logic under the **AU MIDI-controlled Effects** menu. I would like to figure out whether this is a bug in Logic or there's a code change that's required to have it working in Logic as expected.

## Steps to reproduce it

Visit the following link for the code and screen-recordings / screenshots: https://github.com/Nikolozi/AudioUnitV3Experiments/tree/aumf_type

On this branch (`aumf_type`) I have modified of the AUv3FilterExtension plug-in to become `kAudioUnitType_MusicEffect` type instead of ` kAudioUnitType_Effect`.

I've also modified the code so that incoming MIDI notes change the cutoff frequency of the filter. While it's not visually updating the effect can be heard. This works as expected in AUM on iPad (see the screen recording), but in Logic it's not showing up under AU MIDI-controlled Effects. Instead it doubles up the entry under Audio Unit effects menu (see the screenshots).

While Logic Plug-in Manager recognises that the type correctly it doesn't appear in Logic's AU MIDI-controlled Effects menu. Instead it shows two items called "Stereo" under AU effects slot.

I'm also providing a screen recording and screenshots:

1. AUM on iPad, showing that the AUv3FilterExtension (of `aumf` type) inserted in the AUM's effect slot, receiving MIDI from the virtual keyboard and Mela synth playing a Sawtooth. The filter cutoff changing can be heard when different MIDI keys are pressed. The video file can be found at `IssueDetails/Works_correctly_in_AUM.mov`
2. Screenshots in Logic Pro:
   - `IssueDetails/Logic_Plug-in_Manager.png` showing the Logic's Plug-in Manager correctly detects the plug-in type.
   - `IssueDetails/AU_MIDI-controlled_Effects.png` showing that under the AU MIDI-controlled Effects menu AUv3FilterExtension is not showing up.
   - `IssueDetails/Double_entry_in_AU_Effects.png` showing in AU effects menu it's showing "Stereo" twice, it shows only once when the type is `aufx`.

# What's this repo about?

This is a fork of Apple's [CreatingCustomAudioEffects](https://developer.apple.com/documentation/audiotoolbox/audio_unit_v3_plug-ins/creating_custom_audio_effects) sample code. Primary use case for this repo is to demonstrate possible bugs on Apple platforms or in Logic Pro / GarageBand. 

## Compiling
To compile the code, delete `#include "DEVELOPMENT_TEAM.xcconfig"` line in *SampleCode.xcconfig* file and replace it with `DEVELOPMENT_TEAM = XXXXXXXXXX` where `XXXXXXXXXX` is your Apple Develope Team ID.

## Running auval on macOS

For MIDI Plug-in: `auval -v aumi midi Demo`

## Future Plans

Can't be sure.