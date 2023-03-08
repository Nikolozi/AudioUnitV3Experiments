# Issue Details

## Update
I have submitted Developer Technical Support (DTS) regarding this issue, Case-ID: 1674081.

I received a reply that the sample rate is provided to the AUv3 MIDI in `allocateRenderResourcesAndReturnError` through the `format` property of the output bus. And it appears there's a bug in Logic Pro as it doesn't update the sample rate for the AUv3 MIDI plug-ins. I was asked to submit a bug report.

Feedback ID: FB12042397

It also looks it's possble to have audio side chains in MIDI processor plug-ins and it's up to a host to do it.
>It is possible from the standpoint of the `AUAudioUnit` interface to declare a side chain input in a MIDI processor plug-in. A side chain is simply an input bus for instruments, and an extra input bus for effects. However, it is up to the host to provide input to the side chain. This is currently not possible in Logic Pro. If you would like for Apple to consider adding support for such features, please submit your suggestion via Feedback Assistant.

Feedback ID: FB12042407

---
## Description & Steps to reproduce it

**The main question:** how is a MIDI AUv3 plug-in supposed to figure out host's sample rate?

MIDI AUv3 plug-in being of type `aumi / kAudioUnitType_MIDIProcessor`.

In this repo I have a MIDI plug-in, AUv3MIDIDemo, that displays the input & output bus sample rates. I'm assuming the MIDI AUv3 is not required to provide audio bus I/O, is this correct?

Luckily AUM on iOS updates the buses to its sample rate for AUv3 MIDI plug-ins. However, Logic Pro on macOS doesn't seem to update the bus sample rates for AUv3 MIDI plug-ins therefore the question is how should MIDI AUv3s get sample rates from hosts? Or should AUv3 developers assume that this is a bug on Logic's side and always try to get the sample rate from buses?

Visit the following link for the code and video demo: https://github.com/Nikolozi/AudioUnitV3Experiments/tree/auv3_midi_sample_rate

You can inspect code on the `auv3_midi_sample_rate` branch. I have the AUv3MIDIDemo plug-in that displays the samples rates of I/O buses of the AUv3MIDIDemo plug-in.

I'm also providing screen recording:

1. AUM on iPad, showing that the AUv3MIDIDemo observes changes to the host's sample rate. The video file can be found at `IssueDetails/AUv3_MIDI_Plug-in_in_AUM_on_iPad_Sample_Rate_Issue_Demo.mov`
2. Logic Pro showing that the AUv3MIDIDemo stays on the hardcoded 44.1kHz. And looks like Logic doesn't update the sample rate of the I/O buses. The video file can be found at `IssueDetails/AUv3_MIDI_Plug-in_in_Logic_Pro_Sample_Rate_Issue_Demo.mov`

**A bonus question:** Can plug-ins of type kAudioUnitType_MIDIProcessor receive a side chain signal? For example, a plug-in could be an envelope follower, that takes the audio signal via side chain and then generates MIDI output based on the output of the envelope follower. Can this technically be done and it's a matter of hosts supporting it? Can this already be done in Logic?

# What's this repo about?

This is a fork of Apple's [CreatingCustomAudioEffects](https://developer.apple.com/documentation/audiotoolbox/audio_unit_v3_plug-ins/creating_custom_audio_effects) sample code. Primary use case for this repo is to demonstrate possible bugs on Apple platforms or in Logic Pro / GarageBand. 

## Compiling
To compile the code, delete `#include "DEVELOPMENT_TEAM.xcconfig"` line in *SampleCode.xcconfig* file and replace it with `DEVELOPMENT_TEAM = XXXXXXXXXX` where `XXXXXXXXXX` is your Apple Develope Team ID.

## Running auval on macOS

For MIDI Plug-in: `auval -v aumi midi Demo`

## Future Plans

Can't be sure.